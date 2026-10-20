// Standalone sample; not part of the app build.
import React from "react";

export default function GranthList({ granths }) {
  return (
    <ul className="granth-list">
      {granths.map((g) => <li key={g.id}>{g.title}</li>)}
    </ul>
  );
}
// Granth list sample Granth list
