//
//  Recipe.swift
//  AnimationRecipeApp
//
//  Created by Petrus Carvalho on 04/08/23.
//
//
//   let recipeResponse = try? JSONDecoder().decode(RecipeResponse.self, from: jsonData)

import Foundation

// MARK: - RecipeResponse
struct RecipeResponse: Codable {
    let from, to, count: Int
    let hits: [Hit]?
}

// MARK: - Hit
struct Hit: Codable {
    let recipe: Recipe

    enum CodingKeys: String, CodingKey {
        case recipe
    }
}

// MARK: - Recipe
struct Recipe: Codable, Identifiable {
    var id: UUID?
    let uri: String
    let label: String
//    let image: String
    let images: ImagesResponse
//    let source: String
//    let url: String
    let yield: Int
    let healthLabels: [String]
//    let ingredientLines: [String]
//    let ingredients: [Ingredient]
//    let totalWeight: Double
//    let totalTime: Int
//    let cuisineType: [String]
    let totalNutrients: [String: Total]
//    let digest: [Digest]
    
    func getServings() -> String {
        return yield.description + " servings"
    }
    
    func getServingsWithKcal() -> String {
        return getServings() + " - " + String(format: "%.0f", (totalNutrients["ENERC_KCAL"]?.quantity ?? 0) / Double(yield)) + " kcal"
    }
    
    func getHealthLabels() -> String {
        return healthLabels.joined(separator: " • ")
    }
    
    func getImageThumbnail() -> URL {
        return URL(string: images.thumbnail?.url ?? "")!
    }
    
    func getFat() -> String {
        return String(format: "%.0f", (totalNutrients["FAT"]?.quantity ?? 0)) + " " + (totalNutrients["FAT"]?.unit.rawValue ?? "g")
    }
    
    func getCarbs() -> String {
        return String(format: "%.0f", (totalNutrients["CHOCDF"]?.quantity ?? 0)) + " " + (totalNutrients["CHOCDF"]?.unit.rawValue ?? "g")
    }
    
    func getProtein() -> String {
        return String(format: "%.0f", (totalNutrients["PROCNT"]?.quantity ?? 0)) + " " + (totalNutrients["PROCNT"]?.unit.rawValue ?? "g")
    }
    
    func getCholes() -> String {
        return String(format: "%.0f", (totalNutrients["CHOLE"]?.quantity ?? 0)) + " " + (totalNutrients["CHOLE"]?.unit.rawValue ?? "mg")
    }
    
    func getSodium() -> String {
        return String(format: "%.0f", (totalNutrients["NA"]?.quantity ?? 0)) + " " + (totalNutrients["NA"]?.unit.rawValue ?? "mg")
    }
    
    func getCalcium() -> String {
        return String(format: "%.0f", (totalNutrients["CA"]?.quantity ?? 0)) + " " + (totalNutrients["CA"]?.unit.rawValue ?? "mg")
    }
    
    func getMag() -> String {
        return String(format: "%.0f", (totalNutrients["MG"]?.quantity ?? 0)) + " " + (totalNutrients["MG"]?.unit.rawValue ?? "mg")
    }
    
    func getPot() -> String {
        return String(format: "%.0f", (totalNutrients["K"]?.quantity ?? 0)) + " " + (totalNutrients["K"]?.unit.rawValue ?? "mg")
    }
    
    func getIron() -> String {
        return String(format: "%.0f", (totalNutrients["FE"]?.quantity ?? 0)) + " " + (totalNutrients["FE"]?.unit.rawValue ?? "mg")
    }
}

// MARK: - Digest
struct Digest: Codable {
    let label: Label
    let tag: String
    let total: Double
    let hasRDI: Bool
    let daily: Double
    let unit: Unit
    let sub: [Digest]?
}

enum Label: String, Codable {
    case calcium = "Calcium"
    case carbohydratesNet = "Carbohydrates (net)"
    case carbs = "Carbs"
    case carbsNet = "Carbs (net)"
    case cholesterol = "Cholesterol"
    case energy = "Energy"
    case fat = "Fat"
    case fiber = "Fiber"
    case folateEquivalentTotal = "Folate equivalent (total)"
    case folateFood = "Folate (food)"
    case folicAcid = "Folic acid"
    case iron = "Iron"
    case magnesium = "Magnesium"
    case monounsaturated = "Monounsaturated"
    case niacinB3 = "Niacin (B3)"
    case phosphorus = "Phosphorus"
    case polyunsaturated = "Polyunsaturated"
    case potassium = "Potassium"
    case protein = "Protein"
    case riboflavinB2 = "Riboflavin (B2)"
    case saturated = "Saturated"
    case sodium = "Sodium"
    case sugarAlcohols = "Sugar alcohols"
    case sugars = "Sugars"
    case sugarsAdded = "Sugars, added"
    case thiaminB1 = "Thiamin (B1)"
    case trans = "Trans"
    case vitaminA = "Vitamin A"
    case vitaminB12 = "Vitamin B12"
    case vitaminB6 = "Vitamin B6"
    case vitaminC = "Vitamin C"
    case vitaminD = "Vitamin D"
    case vitaminE = "Vitamin E"
    case vitaminK = "Vitamin K"
    case water = "Water"
    case zinc = "Zinc"
}

enum Unit: String, Codable {
    case empty = "%"
    case g = "g"
    case kcal = "kcal"
    case mg = "mg"
    case µg = "µg"
}

// MARK: - Images
struct ImagesResponse: Codable {
    let thumbnail, small, regular: Large?
    let large: Large?

    enum CodingKeys: String, CodingKey {
        case thumbnail = "THUMBNAIL"
        case small = "SMALL"
        case regular = "REGULAR"
        case large = "LARGE"
    }
}

// MARK: - Large
struct Large: Codable {
    let url: String
    let width, height: Int
}

// MARK: - Ingredient
struct Ingredient: Codable {
    let text: String
    let quantity: Double
    let measure: String?
    let food: String
    let weight: Double
    let foodCategory, foodID: String
    let image: String

    enum CodingKeys: String, CodingKey {
        case text, quantity, measure, food, weight, foodCategory
        case foodID = "foodId"
        case image
    }
}

// MARK: - Total
struct Total: Codable {
    let label: Label
    let quantity: Double
    let unit: Unit
}

var recipesMock = [
    Recipe(uri: "http://google.com", label: "Pasta alla Gricia Recipe", images: ImagesResponse(thumbnail: .init(url: "https://edamam-product-images.s3.amazonaws.com/web-img/bb5/bb5bad0cbcb94ad2ef0895d444f30291-s.jpg?X-Amz-Security-Token=IQoJb3JpZ2luX2VjEJ3%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FwEaCXVzLWVhc3QtMSJIMEYCIQCYQ7rKpqI%2B4FU4TmnaI6ptM0Lw7Erex9GWN7AnY1BjngIhANFOwrslAyK1bj8CSEhosr5wkGxirAnW4oub53CicXNLKrkFCEYQABoMMTg3MDE3MTUwOTg2Igzgc67995D6fWIYEnIqlgVfzctYoHdxobiIjQ8lLsA4wEJemOQQvvm5FE8K38JUvcULDeGC7z%2BerNPDmdyzJacEFGOSfWbHCLY8g0CGmVzwIfV62i0wm8g3yRfNJj8IM9Doer7jTaPwHb85SWUs5OfLAbfGGJOvOoSEUxaqf6H264luIaCt2c0gDkVxJVWJDjWAkoD9x9HatcUpv%2FhITtWVBGfAMqPeJbjUO2NcKEd%2BSDFUFd46oTZQhDtob4prMdHjX9U6apC7PBEa1h29nAIVkpDo0uRRXes83OFOC%2Fvfp6Vs6xueh8PJoxd06qOFEZrkjdn%2FvK5e8gc7uRgKrkXzM0Q9qfqQNWC%2B9Kq%2FzoH6ko0rqvP3P3VEMnxS2kY2aDCR2ZBjLnqYquwQ8cF%2FmZ6a1o8CZuAU1H%2FvskebQMqWtb%2BCQW8VRhUy0IGwQTz1YQdR2cRisdm7JnK%2BP3jkrkFC%2BP2PZ5kN0%2BJRnBGJHp4LU%2FHASzndQeEIrP3En2YVfrPsxFvsomoyNlvDqR1P3fNMCKSAH4%2Br5hbmGmI2spDl7Z5kWkAFVHLid4GMwzKi6owfMYZMTvf%2FloFvapw%2F6UaBbzQoclwThvZLP5RF1gz4NQAOoCjAIybnHdr7tqeCeQrj55A%2FdQVUuhP5LY5pTid3rkukqpmICKpo7LnlQOelOgGAmFU0rrcvsCgk8M0rnD7I9Zb%2BOOYEAw59Imh0horFP8CEWZOLsVEC%2Bf1SvmULLKRkz3OUPdQkDXPxtLR1o4DYDThMuB3v9B8L4TINBQNkjuEnYx7C2%2BTm3lX8JACT8HpZGYJvtyEqrPlIlTnk5UJidZXAWiDV1Q43FT3%2BJDecsJa3goYiR2DbOcqN7%2BFlwyTY8tkU7Qyr9tpiOEgWCW%2FPxN6MGzDujLmmBjqwAR%2Fk%2B9Kug2qyah4SGqVkpZANyTADLPFnBTa5OvqcS4MYH0evwvJ1BzCQxvpBIb2v9wttErxnktjQZQyxPnBJSNV4xu8qOcuT0Kyx%2FklwbrF4vMsVBVMwqeo3p5eVu7r41zhj42cwgslPD1oS1jyiTg1Up6FotT3H77Lg%2BGooYV7CiIc1zvoSRooEGp5E3h3OVbQ3Y93IoHjguWl2FbPteOSliHyLfAam3H%2BfDxCYkCvd&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20230805T142740Z&X-Amz-SignedHeaders=host&X-Amz-Expires=3600&X-Amz-Credential=ASIASXCYXIIFCFV6UG2M%2F20230805%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Signature=9b58d1146fb0595579c15dbddca215b974b6631d59e18a19c62e36b4b224a9d0", width: 100, height: 100), small: nil, regular: nil, large: nil), yield: 4, healthLabels: ["Sugar-Conscious","LowPotassium","Kidney-Friendly","Egg-Free","Peanut-Free","Tree-Nut-Free","Soy-Free","Fish-Free","Shellfish-Free","Crustacean-Free","Celery-Free","Mustard-Free","Sesame-Free","Lupine-Free","Mollusk-Free","Alcohol-Free","No oil added","Sulfite-Free"],
        totalNutrients: ["ENERC_KCAL": Total(label: .energy, quantity: 679.535768466108, unit: .kcal),
                         "FAT": Total(label: .fat, quantity: 24.55673908558121, unit: .g),
                         "FASAT": Total(label: .saturated, quantity: 9.386682565239798, unit: .g),
                         "FATRN": Total(label: .trans, quantity: 0.0729291482390625, unit: .g),
                         "FAMS": Total(label: .monounsaturated, quantity: 9.37576554768438, unit: .g),
                         "FAPU": Total(label: .polyunsaturated, quantity: 3.595042172698346, unit: .g),
                         "CHOCDF": Total(label: .carbs, quantity: 85.27330566973988, unit: .g),
                         "CHOCDF.net": Total(label: .carbohydratesNet, quantity: 81.64456670973988, unit: .g),
                         "FIBTG": Total(label: .fiber, quantity: 3.6287389600000006, unit: .g),
                         "SUGAR": Total(label: .sugars, quantity: 3.321819898888589, unit: .g),
                         "PROCNT": Total(label: .protein, quantity: 26.83090943113004, unit: .g),
                         "CHOLE": Total(label: .cholesterol, quantity: 49.90369920908488, unit: .mg),
                         "NA": Total(label: .sodium, quantity: 615.3374932163233, unit: .mg),
                         "CA": Total(label: .calcium, quantity: 201.69029935016798, unit: .mg),
                         "MG": Total(label: .magnesium, quantity: 73.31550553582312, unit: .mg),
                         "K": Total(label: .potassium, quantity: 366.78719386694763, unit: .mg),
                         "FE": Total(label: .iron, quantity: 1.7897495312791023, unit: .mg),
                         "ZN": Total(label: .zinc, quantity: 2.590186090586553, unit: .mg),
                         "P": Total(label: .phosphorus, quantity: 422.07775950100495, unit: .mg),
                         "VITA_RAE": Total(label: .vitaminA, quantity: 21.297283201294693, unit: .µg),
                         "VITC": Total(label: .vitaminC, quantity: 0, unit: .mg),
                         "THIA": Total(label: .thiaminB1, quantity: 0, unit: .mg),
                         "RIBF": Total(label: .riboflavinB2, quantity: 0, unit: .mg),
                         "NIA": Total(label: .niacinB3, quantity: 0, unit: .mg),
                         "VITB6A": Total(label: .vitaminB6, quantity: 0, unit: .mg),
                         "FOLDFE": Total(label: .folateEquivalentTotal, quantity: 0, unit: .mg),
        ]
    )
]
