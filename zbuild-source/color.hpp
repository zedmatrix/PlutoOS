#pragma once
#include <algorithm>
#include <cctype>
#include <print>
#include <string>
#include "screen.hpp"

namespace Color {
    enum class Code : uint8_t {
        BLACK = 30,
        RED = 31,
        GREEN = 32,
        YELLOW = 33,
        BLUE = 34,
        MAGENTA = 35,
        CYAN = 36,
        WHITE = 37,
        DEFAULT = 0
    };
}

inline std::string reset() { return "\033[0m"; }
inline std::string pos(uint16_t x) { return std::format("\033[{}G", x); }

template<typename T>
static std::string color(bool bold, T code) {
    static_assert(std::is_enum_v<T> || std::is_integral_v<T>, "color() requires an enum or integral type");
    uint8_t c = static_cast<uint8_t>(code);
    return "\033[" + std::string(bold ? "1;" : "") + std::to_string(c) + "m";
}
struct Label {
    std::string text;
    Color::Code color;
    size_t xpos = 1;
};
template<>
struct std::formatter<Label> : std::formatter<std::string> {
    template<typename FormatContext>
    auto format(const Label& l, FormatContext& ctx) const {
        auto colored_text = std::format("{}{}", color(true, l.color), l.text);
        auto enclosed = std::format("{}{}[{}{}]{}",
            pos(l.xpos),
            color(true, Color::Code::BLUE),
            colored_text,
            color(true, Color::Code::BLUE),
            reset()
        );
        return std::formatter<std::string>::format(enclosed, ctx);
    }
};
