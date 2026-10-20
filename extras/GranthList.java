// Standalone sample; not part of the app build.
import java.util.List;

public class GranthList {
    public static void main(String[] args) {
        List<String> granths = List.of("Gita", "Kabir Sagar", "Ved");
        for (int i = 0; i < granths.size(); i++) System.out.println((i + 1) + ". " + granths.get(i));
    }
}
