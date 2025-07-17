#include "zbuild.hpp"

Zbuild::Zbuild() {
    ///Empty
}
/// Initialize Package Definitions
int Zbuild::init(std::string file) {
    //TODO /etc/zbuild.conf
    //if (!loadConfig("/zbuild/zbuild.cfg")) { zzdie("Error: Can Not Load Configuration File!"); return 127; }
    if (!loadConfig("zbuild.cfg")) { zzdie("Error: Can Not Load Configuration File!"); return 127; }

    m_sourcedir = std::filesystem::absolute(std::filesystem::path(parseVector(m_vectorConfig, "zbuild_source")));
    if (m_sourcedir.empty()) { zzdie("Missing SOURCE dir. Exiting."); return 69; }
    m_rootdir = std::filesystem::absolute(std::filesystem::path(parseVector(m_vectorConfig, "zbuild_root")));
    if (m_rootdir.empty()) { zzdie("Missing ROOT dir. Exiting."); return 68; }
    m_logdir = std::filesystem::absolute(std::filesystem::path(parseVector(m_vectorConfig, "zbuild_log")));
    if (m_logdir.empty()) { zzdie("Missing LOG dir. Exiting."); return 67; }
    m_tmpdir = std::filesystem::absolute(std::filesystem::path(parseVector(m_vectorConfig, "zbuild_tmp")));
    if (m_tmpdir.empty()) { zzdie("Missing TMP dir. Exiting."); return 66; }

    if (!loadPackage(m_packageMap, file.c_str())) {
        zzerror("Error Loading Package Configuration File");
        return 65;
    }
    // Primary Package Definitions
    m_pkgdir = std::filesystem::path(parseMap(m_packageMap, "pkgdir"));
    if (m_pkgdir.empty()) return 9;
    if ((m_pkgname = parseMap(m_packageMap, "pkgname")).empty()) return 8;
    if ((m_pkgver = parseMap(m_packageMap, "pkgver")).empty()) return 7;
    if ((m_pkgurl = parseMap(m_packageMap, "pkgurl")).empty()) return 6;
    if ((m_pkgrel = parseMap(m_packageMap, "pkgrel")).empty()) m_pkgrel = "1";
    m_archive = getBaseName(m_pkgurl);
    m_archivedir = absolutePath(m_sourcedir, std::filesystem::path(m_archive));

    // Build Functions (prepare /build /test /install /post)
    if ((m_build = parseMap(m_packageMap, "build")).empty()) return 5;
    if ((m_install = parseMap(m_packageMap, "install")).empty()) return 4;
    m_check = parseMap(m_packageMap, "check");
    m_prepare = parseMap(m_packageMap, "prepare");
    m_preconfig = parseMap(m_packageMap, "preconfig");
    m_post = parseMap(m_packageMap, "post");
    m_postconfig = parseMap(m_packageMap, "postconfig");
    // Package Definitions
    m_pkgsum = parseMap(m_packageMap, "md5sum");
    if (m_pkgsum.empty()) {
        m_sha256 = true;
        m_pkgsum = parseMap(m_packageMap, "sha256sum");
        if (m_pkgsum.empty()) {
            zzprintln("Missing Package Sum");
            return 3;
        }
    }
    // Sets to True unless set in package def
    m_ZarcBool = !parseMap(m_packageMap, "zarchive").contains("false");

    m_ZarcFile = absolutePath(m_tmpdir, m_pkgdir);
    m_ZarcFile += ".tar.xz";

    //m_ZarcFile = absolutePath(m_tmpdir, std::filesystem::path(m_pkgdir + std::string(".tar.xz")));

    // single patch file
    // TODO multi patch download
    m_patchurl = parseMap(m_packageMap, "patchurl");
    if (!m_patchurl.empty()) {
        m_patch = getBaseName(m_patchurl);
        m_patchdir = absolutePath(m_sourcedir, m_patch);
        m_patchmd5 = parseMap(m_packageMap, "patchmd5");
        if (m_patchmd5.empty()) return 3;
    }
    // additional document download
    m_docurl = parseMap(m_packageMap, "docurl");
    if (!m_docurl.empty()) {
        m_docfile = getBaseName(m_docurl);
        m_docfiledir = absolutePath(m_sourcedir, m_docfile);
        m_docmd5 = parseMap(m_packageMap, "docmd5");
        if (m_docmd5.empty()) return 3;
    }

    // Create Package Directory
    m_builddir = absolutePath(m_tmpdir, m_pkgdir);
    if (!checkExist(m_builddir)) {
        if (!make_dir(m_builddir)) {
            fail("Build Dir Creation Failed");
            return 2;
        }
        if (!make_dir(m_logdir / m_pkgdir)) {
            return 2;
        }
    }
    return 0;
}

// Download ? package or patch using libcurl
int Zbuild::getPackage() {
    if (!checkExist(m_archivedir)) {
        zzprintln(" Downloading: {} ", m_pkgname);
        std::string tempSUM = download(m_pkgurl, m_archivedir, m_sha256);

        if (tempSUM.empty() || tempSUM != m_pkgsum) {
            fail(std::format("Failed To Download: {} \nChecksum Error:{}", m_archive, tempSUM));
            return 19;
        }
        pass();
    }
    if (!m_patchurl.empty()) {
        if (!checkExist(m_patchdir)) {
            zzprintln(" Downloading: {} ", m_patch);
            std::string tempMD5 = download(m_patchurl, m_patchdir);
            if (tempMD5.empty() || tempMD5 != m_patchmd5) {
                fail(std::format("Failed To Download: {} \nChecksum Error:{}", m_patch, tempMD5));
                return 18;
            }
            pass();
        }
    }
    if (!m_docurl.empty()) {
        if (!checkExist(m_docfiledir)) {
            zzprintln(" Downloading: {} ", m_docfile);
            std::string tempMD5 = download(m_docurl, m_docfiledir);
            if (tempMD5.empty() || tempMD5 != m_docmd5) {
                fail(std::format("Failed To Download: {} \nChecksum Error:{}", m_docfile, tempMD5));
                return 17;
            }
            pass();
        }
    }

    pass();
    return 0;
}
// retrieve package info for manager
PackageInfo Zbuild::getPackageInfo() {
    PackageInfo pkg;
    pkg.name = m_pkgname;
    pkg.version = m_pkgver;
    pkg.url = m_pkgurl;
    return pkg;
}

// load primary config
bool Zbuild::loadConfig(const char* filePath) {
    std::ifstream file(filePath, std::ios::in);
    if (!file.is_open()) {
        return false;
    }
    std::string line;
    while (getline(file, line, '\n')) {
        line = trim(line, '"');
        m_vectorConfig.emplace_back(line);
    }
    file.close();
    return true;
}
//Logging m_logdir / m_pkgdir / fileName && status = m_status.code == 0
bool Zbuild::writeLog(std::string fileName, std::string& data, bool status) {
    std::filesystem::path filePath = m_logdir / m_pkgdir / fileName.c_str();
    FILE *fp = fopen(filePath.string().c_str(), "w");
    if (!fp) {
        perror("fopen");
        return false;
    }
    std::println(fp, "{}{}", (status ? "PASSED\n" : "FAILED\n"), data);
    return true;
}
bool Zbuild::readLog(std::string filePath) {
    std::ifstream file(filePath);
    if (!file) {
        std::perror("ifstream");
        return false;
    }
    std::string result;
    std::getline(file, result);
    if (result.find("PASSED") != std::string::npos) return true;
    return false;
}

// Patch Package
int Zbuild::patch() {
    m_status.code = 0;
    if (!m_patchdir.empty()) {
        if (!change_dir(m_builddir)) {
            zzprintln("Error: Change Dir Fail in Patch");
            return 99;
        }
        current_path();
        m_command = std::format("patch -Np1 -i {}", m_patchdir.string());
        m_status = runWithCapture(m_command, false);
        if (!m_status.output.empty()) {
            writeLog("patch.log", m_status.output, m_status.code == 0);
        }
    }
    return m_status.code;
}

// Prepare Function
int Zbuild::prepare() {
    //TODO skip prepare if passed ?
    m_status.code = 0;
    if (!m_preconfig.empty()) {
        if (!change_dir(m_builddir)) {
            zzprintln("Error: Could Not Change To {} For \n {}", m_builddir.string(), m_preconfig);
            return 88;
        }
        m_status.code = executeCommand(m_preconfig);
        if (m_status.code != 0) {
            return 88;
        }
    }
    if (!m_prepare.empty()) {
        if (!change_dir(m_builddir)) {
            zzprintln("Error: Could Not Change To {} For \n {}", m_builddir.string(), m_prepare);
            return 88;
        }
        zzprintln(" Preparing: {} ", m_pkgname);
        m_status = runWithCapture(m_prepare);
        if (!m_status.output.empty()) {
            writeLog("prepare.log", m_status.output, m_status.code == 0);
        }
    }
    return m_status.code;
}

//Build Package --- Main Function REQUIRED
int Zbuild::buildPackage() {
    //TODO skip build if passed ?
    zzprintln(" Building: {} ", m_pkgname);
    if (!change_dir(m_builddir)) {
        zzprintln("Error: Could Not Change To {} For \n {}", m_builddir.string(), m_build);
        return 77;
    }
    m_status = runWithCapture(m_build);
    if (!m_status.output.empty()) {
        writeLog("build.log", m_status.output, m_status.code == 0);
    }
    return m_status.code;
}

// Check Package - Optional
int Zbuild::checkPackage() {
    //TODO skip check if set false ?
    m_status.code = 0;
    if (!m_check.empty()) {
        zzprintln(" Checking: {} ", m_pkgname);
        if (!change_dir(m_builddir)) {
            zzprintln("Error: Could Not Change To {} For \n {}", m_builddir.string(), m_check);
            return 77;
        }
        m_status = runWithCapture(m_check);
        if (!m_status.output.empty()) {
            writeLog("check.log", m_status.output, m_status.code == 0);
        }
    }
    return m_status.code;
}

// Install Package --- Main Function REQUIRED
int Zbuild::installPackage() {
    //TODO skip install or destdir feature
    zzprintln(" Installing: {} ", m_pkgname);
    if (!change_dir(m_builddir)) {
        zzprintln("Error: Could Not Change To {} For \n {}", m_builddir.string(), m_install);
        return 66;
    }
    m_status = runWithCapture(m_install);
    if (!m_status.output.empty()) {
        writeLog("install.log", m_status.output, m_status.code == 0);
    }
    return m_status.code;
}

// Post Package - Optional
int Zbuild::postPackage() {
    m_status.code = 0;
    if (!m_post.empty()) {
        zzprintln(" Post Package: {} ", m_pkgname);
        if (!change_dir(m_builddir)) {
            zzprintln("Error: Could Not Change To {} For \n {}", m_builddir.string(), m_post);
            return 55;
        }
        m_status = runWithCapture(m_post);
        if (!m_status.output.empty()) {
            writeLog("post.log", m_status.output, m_status.code == 0);
        }
    }
    if (!m_postconfig.empty()) {
        zzprintln(" Post Configuration: {} ", m_pkgname);
        if (!change_dir(m_builddir)) {
            zzprintln("Error: Could Not Change To {} For \n {}", m_builddir.string(), m_postconfig);
            return 55;
        }
        m_status.code = executeCommand(m_postconfig);
    }
    //TODO clean up build directory
    return m_status.code;
}

//Filesystem Functions
bool Zbuild::make_dir(const std::filesystem::path& dir) {
    std::error_code ec;
    bool created = std::filesystem::create_directories(dir, ec);
    if (ec) {
        zzprintln("Failed to create directory {}: {}", dir.string(), ec.message());
        return false;
    }
    if (created) {
        zzprintln("Created directory: {}", dir.string());
    } else {
        zzprintln("Directory already exists: {}", dir.string());
    }
    return true; // returns true if new dirs were created, false if already existed
}

bool Zbuild::change_dir(const std::filesystem::path& dir) {
    if (dir.empty()) {
        current_path();
        return true;
    }
    try {
        std::filesystem::path target = std::filesystem::absolute(dir);
        if (!std::filesystem::equivalent(std::filesystem::current_path(), target)) {
            zzprintln(" Changing To: {} ", dir.string());
            std::filesystem::current_path(dir);
        }
        return true;
    } catch (const std::filesystem::filesystem_error& e) {
        std::println("*** Error changing directory: {}", e.what());
        return false;
    }
}
