// Standalone sample; not part of the app build.
using System;

namespace Granth;

public static class GranthList
{
    public static void Main()
    {
        string[] granths = { "Gita", "Kabir Sagar", "Ved" };
        for (var i = 0; i < granths.Length; i++) Console.WriteLine($"{i + 1}. {granths[i]}");
    }
}
