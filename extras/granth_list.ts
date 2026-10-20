// Standalone sample; not part of the app build.
interface Granth { id: number; title: string }

const granths: Granth[] = [{ id: 1, title: "गीता" }, { id: 2, title: "कबीर सागर" }];
for (const g of granths) console.log(`${g.id}. ${g.title}`);
// Granth li
