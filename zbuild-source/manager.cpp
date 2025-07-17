#include "manager.hpp"

Manager::Manager(std::string package) : m_package(package) {
    // Empty
}

int Manager::run() {
    // TODO dep check

    using Step = std::pair<std::string_view, std::function<int()>>;
    std::vector<Step> steps = {
        {"Initialization", [&]() { return zbuild.init(m_package); }},
        {"Downloading", [&]() { return zbuild.getPackage(); }},
        {"Extraction", [&]() { return zbuild.extract(); }},
        {"Patching", [&]() { return zbuild.patch(); }},
        {"Preparing", [&]() { return zbuild.prepare(); }},
        {"Build Package", [&]() { return zbuild.buildPackage(); }},
        {"Check Package", [&]() { return zbuild.checkPackage(); }},
        {"Install Package", [&]() { return zbuild.installPackage(); }},
        {"Post Package", [&]() { return zbuild.postPackage(); }}
    };
    // TODO record failed attempts ... restart?

    for (const auto& [name, func] : steps) {
        m_returnCode = func();
        if (m_returnCode != 0) {
            std::string errMsg = ZError.contains(m_returnCode)
                         ? ZError.at(m_returnCode)
                         : "Unknown Error";
            std::println("{} Failure! Error Code: {} :[{}]", name, m_returnCode, errMsg);
            if (name == "Check Package") continue;
            return m_returnCode;
        }
    }

    // Package Archiver and Remove tmp

    //TODO remove source directory (added a tmp dir for building packages)
    return 0;
}
bool Manager::archiver() {
    if (zbuild.getZarcBool()) {
        if (!zbuild.archivePackage()) {
            std::println("Error Creating Package Archive!");
            return false;
        }
        std::println("Package Archive Created!");
    } else {
        std::println("Skipping Package Archiver!");
    }

    if (!zbuild.removeTmpdir()) {
        std::println("Error Removing Temporary Directory!");
        return false;
    }

    return true;
}

bool Manager::writePackageDB() {
    PackageInfo pkg;
    pkg = zbuild.getPackageInfo();
    std::string data = std::format("{} - {} - {}", pkg.name, pkg.version, pkg.url);
    std::filesystem::path filePath = zbuild.getRootDir() / "zpackage.db";
    FILE *fp = fopen(filePath.string().c_str(), "a");
    if (!fp) {
        perror("fopen");
        return false;
    }
    std::println(fp, "{}", data);
    return true;
}
