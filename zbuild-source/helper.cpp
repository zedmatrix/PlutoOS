#include "helper.hpp"
EVP_MD_CTX* mdctx;

std::string trim(std::string& str, char what) {
    std::string result = str;
    result.erase(std::remove(result.begin(), result.end(), what), result.end());
    return result;
}

std::string parseVector(std::vector<std::string>& pkg, std::string what) {
    std::string result = "";
    for(std::string line : pkg) {
        if (line.starts_with(what)) {
            int pos = line.find_first_of("=");
            result = line.substr(pos + 1);
            std::string key = line.substr(0, pos); //test
            std::println("vector: key:{}  value:{}", key, result); //test
        }
    }
    return result;
}
std::string_view parseMap(const std::map<std::string, std::string>& map, const std::string& key) {
    auto it = map.find(key);
    if (it != map.end()) {
        return it->second;
    }
    return {};
}

std::string getBaseName(std::string_view view) {
    std::string str(view);
    auto last_slash = str.find_last_of('/');
    if (last_slash != std::string::npos) {
        std::println("basename: {}", str.substr(last_slash + 1)); //test
        return str.substr(last_slash + 1);
    }
    return "";
}

bool checkExist(std::filesystem::path filePath) {
    if (std::filesystem::exists(filePath)) {
        return true;
    }
    return false;
}

size_t write_callback(char* ptr, size_t size, size_t nmemb, void* userdata) {
    size_t total = size * nmemb;

    // Write to file
    FILE* fp = static_cast<FILE*>(userdata);
    size_t written = fwrite(ptr, size, nmemb, fp);

    // Update hash
    EVP_DigestUpdate(mdctx, ptr, total);
    return written;
}

std::string download(std::string_view view, const std::filesystem::path& filePath, bool sha256/* = false*/) {
    std::string url(view);
    std::string result = "";
    unsigned char hash[EVP_MAX_MD_SIZE];
    unsigned int hash_len;

    CURL *curl = curl_easy_init();
    if (!curl) {
        fprintf(stderr, "Failed to initialize curl.\n");
        return "";
    }
    mdctx = EVP_MD_CTX_new();
    const EVP_MD* digest = sha256 ? EVP_sha256() : EVP_md5();
    EVP_DigestInit_ex(mdctx, digest, NULL);

    FILE *fp = fopen(filePath.string().c_str(), "wb");
    if (!fp) {
        perror("fopen");
        curl_easy_cleanup(curl);
        return "";
    }
    curl_easy_setopt(curl, CURLOPT_URL, url.c_str());
    curl_easy_setopt(curl, CURLOPT_WRITEDATA, fp);
    curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, write_callback);
    curl_easy_setopt(curl, CURLOPT_FAILONERROR, 1L);
    curl_easy_setopt(curl, CURLOPT_FOLLOWLOCATION, 1L);
    curl_easy_setopt(curl, CURLOPT_NOPROGRESS, 0L);
    curl_easy_setopt(curl, CURLOPT_USERAGENT, "curl/8.7.1");

    CURLcode res = curl_easy_perform(curl);
    if (res != CURLE_OK) {
        std::println("Download failed: {}", curl_easy_strerror(res));
        std::filesystem::remove(filePath);
        result = "";
    } else {
        EVP_DigestFinal_ex(mdctx, hash, &hash_len);
        EVP_MD_CTX_free(mdctx);
        std::ostringstream oss;
        for (unsigned int i = 0; i < hash_len; ++i) {
            oss << std::hex << std::setw(2) << std::setfill('0') << (int)hash[i];
        }

        std::println("Download successful: {} \nChecksum: {}", filePath.string(), oss.str());
        result = oss.str();
    }

    fclose(fp);
    curl_easy_cleanup(curl);
    return result;
}

constexpr char START_DELIM = '[';
constexpr char END_DELIM = ']';

bool loadPackage(std::map<std::string, std::string>& map, const char* filePath) {
    std::ifstream file(filePath);
    if (!file.is_open()) return false;
    std::string line;
    std::string currentKey;
    std::string block;
    bool in_paren_block = false;
    int paren_depth = 0;

    while (std::getline(file, line)) {
        size_t eq_paren = line.find_first_of('=');
        if (!in_paren_block && eq_paren != std::string::npos) {
            currentKey = line.substr(0, eq_paren);
            size_t open = line.find_first_of(START_DELIM, eq_paren);
            size_t close = line.find_last_of(END_DELIM);

             // One-liner: key=(value)
            if (close != std::string::npos) {
                block = line.substr(open + 1, close - open - 1);
                map[currentKey] = block;
                currentKey.clear();
                block.clear();
            } else {
                in_paren_block = true;      // Multi-line start
                paren_depth = 1;
                if (open != std::string::npos && open + 1 < line.size()) {
                    block = line.substr(open + 1) + "\n";
                } else {
                    block.clear();
                }
            }
            continue;
        }
        if (in_paren_block) {
            paren_depth += std::count(line.begin(), line.end(), START_DELIM);
            paren_depth -= std::count(line.begin(), line.end(), END_DELIM);

            if (paren_depth <= 0) {
                size_t close = line.find(END_DELIM);
                if (close != std::string::npos) {
                    block += line.substr(0, close) + "\n";
                } else {
                    block += line + "\n";
                }
                in_paren_block = false;
                if (!block.empty() && block.back() == '\n')
                    block.pop_back();
                map[currentKey] = block;
                block.clear();
                currentKey.clear();
            } else {
                block += line + "\n";
            }
        }
    }
    return true;
}
