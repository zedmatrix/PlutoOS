#pragma once
#include <print>
#include <string>
#include <string_view>
#include <fstream>
#include <vector>
#include <map>
#include <filesystem>
#include <sstream>
#include <iostream>
#include <curl/curl.h>
#include <iomanip>
#include <openssl/evp.h>
#include <functional>

struct ReturnStatus {
    int code;
    std::string output;
};

size_t write_callback(char* ptr, size_t size, size_t nmemb, void* userdata);

std::string trim(std::string& str, char what);
std::string parseVector(std::vector<std::string>& pkg, std::string what);
std::string getBaseName(std::string_view view);

bool checkExist(std::filesystem::path filePath);

ReturnStatus runWithCapture(std::string& cmd, bool flag = true);
int executeCommand(std::string& cmd);

std::string download(std::string_view view, const std::filesystem::path& filePath, bool sha256 = false);

bool loadPackage(std::map<std::string, std::string>& map, const char* filePath);

std::string_view parseMap(const std::map<std::string, std::string>& map, const std::string& key);
