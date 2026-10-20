// Standalone sample; not part of the app build.
import React from "react";
import { FlatList, Text } from "react-native";

type Granth = { id: string; title: string };

export function GranthList({ data }: { data: Granth[] }) {
  return <FlatList data={data} keyExtractor={(g) => g.id} renderItem={({ item }) => <Text>{item.title}</Text>} />;
}
