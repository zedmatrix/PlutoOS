#include "zbuild.hpp"

bool Zbuild::archivePackage() {
    zzprintln(" Archiving: {} ", m_pkgdir.string());
    m_status.code = -1;
    m_command = std::format("tar -cJvf {} -C {} {}",
                            m_ZarcFile.string(),
                            m_tmpdir.string(),
                            m_pkgdir.string());
    m_status = runWithCapture(m_command, false);
    if (!m_status.output.empty()) {
        writeLog("archive.log", m_status.output, m_status.code == 0);
    }
    return m_status.code == 0;
}

bool Zbuild::removeTmpdir() {
    // m_builddir = absolutePath(m_tmpdir, m_pkgdir);
    try {
        return std::filesystem::remove_all(m_builddir) > 0;
    } catch (const std::filesystem::filesystem_error& e) {
        std::cerr << "Failed to remove tmpdir: " << e.what() << '\n';
        return false;
    }
}

// Package Extraction
int Zbuild::extract() {
    const auto logPath = m_logdir / m_pkgdir / "extract.log";
    if (checkExist(logPath)) {
        if (readLog(logPath)) return 0;
    }

    zzprintln(" Extracting: {} ", m_pkgname);
    if (m_archive.contains(".zip")) {
    // hopefully bsdunzip is installed
        m_command = std::format("bsdunzip -d {} {}",
                                m_builddir.string(),
                                m_archivedir.string());

    } else {
    // default archive using tar
        m_command = std::format("tar -xvf {} -C {} --strip-components={}",
                            m_archivedir.string(),
                            m_builddir.string(),
                            m_pkgrel);
    }
    m_status.code = -1;
    m_status = runWithCapture(m_command, false);
    if (!m_status.output.empty()) {
        writeLog("extract.log", m_status.output, m_status.code == 0);
    }
    return m_status.code;
}
