#include <boost/version.hpp>
#include <iostream>
#include <sstream>
#include "helper.hpp"

#if BOOST_VERSION >= 108800
// Boost 1.88 - use POSIX popen for simplicity and reliability
#include <cstdio>
#include <memory>
#include <stdexcept>
#include <array>

ReturnStatus runWithCapture(std::string& cmd, bool flag/* = true*/) {
    ReturnStatus result;
    std::println("Executing: {}", cmd);
    std::unique_ptr<FILE, decltype(&pclose)> pipe(popen(cmd.c_str(), "r"), pclose);

    if (!pipe) {
        result.code = -1;
        return result;
    }

    std::array<char, 128> buffer;
    while (fgets(buffer.data(), buffer.size(), pipe.get()) != nullptr) {
        std::string line(buffer.data());
        if (!line.empty() && line.back() == '\n') {
            line.pop_back();
        }

        result.output += line + '\n';
        if (flag) std::println(">>> {}", line);
    }
    result.code = pclose(pipe.release()) / 256;
    return result;
}

int executeCommand(std::string& cmd) {
    std::println("Executing: {}", cmd);
    int ret = std::system(cmd.c_str());
    return ret / 256;
}

#else

#include <boost/process.hpp>
// Boost 1.87 or older - use legacy compatible code here
ReturnStatus runWithCapture(std::string& cmd, bool flag/* = true*/) {
    ReturnStatus result;
    std::println("Executing: {}", cmd);
    std::ostringstream output;
    boost::process::ipstream pipe_stream;
    boost::process::child c(boost::process::shell, cmd, boost::process::std_out > pipe_stream);
    std::string line;
    while (pipe_stream && std::getline(pipe_stream, line)) {
        result.output += line + '\n';
        if (flag) std::println(">>> {}", line);
    }
    c.wait();
    result.code = c.exit_code();
    return result;
}

int executeCommand(std::string& cmd) {
    std::println("Executing: {}", cmd);
    int ret = boost::process::system(boost::process::shell, cmd);
    return ret;
}
#endif
