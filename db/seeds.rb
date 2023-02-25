json = JSON.parse(File.read("db/categories.json"))

Category.upsert_all(json)
