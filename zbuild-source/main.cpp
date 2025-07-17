#include <filesystem>
#include <print>
#include "manager.hpp"

template<typename T>
auto duration(T&& value) {
    std::string str = "";
    int dur = static_cast<int>(value);
    int h = dur / 3600;
    int m = (dur % 3600 / 60);
    int s = (dur % 3600 % 60);

    str = (h > 1) ? std::format("{} Hours ", h) : (h > 0) ? std::format("{} Hour ", h) : "";
    str += (m > 1) ? std::format("{} Minutes ", m) : (m > 0) ? std::format("{} Minute ", m) : "";
    str += (s > 1) ? std::format("{} Seconds ", s) : (s > 0) ? std::format("{} Second ", s) : "";
    return std::format("{}", str);
}

int main(int argc, char* argv[]) {
    constexpr std::string_view reset = "\033[0m";
    constexpr std::string_view green = "\033[1;32m";
    constexpr std::string_view red   = "\033[1;31m";

    std::string success = std::format("{}{}{}", green, std::string(40,'*'), reset);
    std::string failure = std::format("{}{}{}", red, std::string(40,'*'), reset);
    std::string file;

    if (argc > 1) {
        file = argv[1];
    }
    if (!std::filesystem::exists(file)) {
        std::println("Error Package File Does Not Exist");
        return 1;
    }

    Manager manager(file);
    manager.setStartTime();

    std::println("{}", success);

    int ret = manager.run();
    manager.setStopTime();

    if (ret != 0) {
        std::println("{}\n\tPackage Failure: Error: {}", failure, ret);
        return ret;
    }
    std::println("{}\n\tPackage Successful!", success);

    if (manager.archiver()) {
        std::println("Package Build Directory Removed!");
    }

    if (manager.writePackageDB()) {
        std::println("Package Database Updated!");
    } else {
        std::println("Package Database Write Failure!");
    }

    std::println("Build Time: {}\n{}", duration(manager.getDuration().count()), success);

    return 0;
}
