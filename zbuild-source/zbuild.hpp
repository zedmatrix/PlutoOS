#ifndef ZBUILD_HPP
#define ZBUILD_HPP

#include <print>
#include <string>
#include <vector>
#include <map>
#include <fstream>
#include <optional>
#include <cstdlib>
#include <filesystem>
#include "helper.hpp"
#include "screen.hpp"
#include "color.hpp"

template<typename... Args>
void zzprintln(std::format_string<Args...> fmt, Args&&... args) {
    std::string text = std::format(fmt, std::forward<Args>(args)...);
    std::println("{}", Label{text, Color::Code::YELLOW});
}

struct PackageInfo {
    std::string name;
    std::string version;
    std::string url;
};

class Zbuild {

public:
    Zbuild();
    int init(std::string file);
    int getPackage();
    int extract();
    int patch();
    int prepare();
    int buildPackage();
    int checkPackage();
    int installPackage();
    int postPackage();

    // Getter
    PackageInfo getPackageInfo();
    std::filesystem::path getRootDir() { return m_rootdir; }
    std::filesystem::path getBuildDir() { return m_builddir; }
    std::filesystem::path getZarcFile() { return m_ZarcFile; }
    bool getZarcBool() { return m_ZarcBool; }
    bool archivePackage();
    bool removeTmpdir();

private:
    ReturnStatus m_status;
    bool loadConfig(const char* filePath);
    bool writeLog(std::string fileName, std::string& data, bool status);
    bool readLog(std::string filePath);

    bool make_dir(const std::filesystem::path& dir);
    bool change_dir(const std::filesystem::path& dir);
    std::filesystem::path m_tmpdir, m_logdir, m_rootdir, m_sourcedir, m_ZarcFile;
    std::filesystem::path m_builddir, m_currentpath;
    std::filesystem::path m_pkgdir, m_patchdir, m_archivedir, m_docfiledir;
    std::string absolutePath(const std::filesystem::path& base, const std::filesystem::path& sub) {
        return std::filesystem::absolute(base / sub);
    }
    void current_path() {
        m_currentpath = std::filesystem::current_path();
        zzprintln("Current path: {}", m_currentpath.string());
    }

    std::vector<std::string> m_vectorConfig;
    std::map<std::string, std::string> m_packageMap;
    std::string m_archive, m_patch, m_command, m_docfile;
    std::string m_build, m_check, m_install, m_pkgrel;
    std::string m_prepare, m_preconfig, m_post, m_postconfig;
    std::string_view m_pkgname, m_pkgver, m_pkgurl, m_patchurl, m_docurl;
    std::string_view m_patchmd5, m_pkgsum, m_docmd5;
    bool m_sha256 = false;
    bool m_ZarcBool = true;

    void zzerror(std::string text) { std::println("{}", text); }
    void zzdie(std::string text) { std::println("{}", text); }

    std::string position_x(uint16_t x) { return std::format("\033[{}G", x); }

    void pass() {
        size_t pos = SCREEN_WIDTH - 6;
        std::println("{}", Label{"PASS", Color::Code::GREEN, pos});
    }
    void fail(std::string text) {
        size_t pos = SCREEN_WIDTH - (text.size() + 2);
        std::println("{}{}", text, Label{"FAIL", Color::Code::RED, pos});
    }
};
#endif //ZBUILD_CPP

/* size_t pos = SCREEN_WIDTH - (text.size() + 2);
        std::println("{}", Label{text, Color::Code::RED, pos});
*/
