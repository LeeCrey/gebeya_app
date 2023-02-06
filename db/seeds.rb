json = JSON.parse(File.read("db/categories.json"))

Category.create(json)
