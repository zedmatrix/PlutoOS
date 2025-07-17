#ifndef MANAGER_HPP
#define MANAGER_HPP
#include <map>
#include <vector>
#include <string>
#include <string_view>
#include <chrono>
#include "zbuild.hpp"

const std::map<int, std::string> ZError = {
    {0, "No Error"},
    {2, "Directory Creation Failed"},
    {3, "Missing Checksum"},
    {4, "Missing Install"},
    {5, "Missing Build"},
    {6, "Missing pkgurl"},
    {7, "Missing pkgver"},
    {8, "Missing pkgname"},
    {9, "Missing pkgdir"},
    {17, "Download Doc File Error"},
    {18, "Download Patch Error"},
    {19, "Download Package Error"},
    {55, "Post Function Failure"},
    {65, "Installation Function Failure"},
    {66, "Missing TMP Dir"},
    {67, "Missing LOG Dir"},
    {68, "Missing ROOT Dir"},
    {69, "Missing SOURCE Dir"},
    {77, "Build Function Failure"},
    {88, "Prepare Function Failure"},
    {99, "Applying Patch Failed"},
    {127, "Missing Config File"},
    // Add more as needed
};

class Manager {

public:

    Manager(std::string package);
    int run();

    void setStartTime() { m_startTime = std::chrono::steady_clock::now(); }
    void setStopTime() { m_stopTime = std::chrono::steady_clock::now(); }
    std::chrono::duration<double> getDuration() { return m_stopTime - m_startTime; }

    bool archiver();
    bool writePackageDB();

private:
    Zbuild zbuild;
    std::string m_package;
    int m_returnCode;

    std::chrono::steady_clock::time_point m_startTime;
    std::chrono::steady_clock::time_point m_stopTime;

};

#endif //MANAGER_HPP
