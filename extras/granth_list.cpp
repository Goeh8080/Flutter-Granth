// Standalone sample; not part of the app build.
#include <iostream>
#include <vector>
#include <string>

int main() {
    std::vector<std::string> granths{"Gita", "Kabir Sagar", "Ved"};
    int i = 1;
    for (const auto &g : granths) std::cout << i++ << ". " << g << '\n';
}
