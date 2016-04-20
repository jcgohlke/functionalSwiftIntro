//: Most examples taken from Chris Eidhof and team's excellent book, "Functional Swift". Check out the website [here](https://www.objc.io/books/functional-swift/) to order a copy.

//: ## Filter
//: A function defined in the Swift Standard Library, but shown here as a generic to emphasize that the function is not special and could in fact be defined (and is represented internally), as such.
let exampleFiles = ["README.md", "HelloWorld.swift", "FlappyBird.swift"]

func getSwiftFiles(files: [String]) -> [String]
{
    var result: [String] = []
    for file in files
    {
        if file.hasSuffix(".swift")
        {
            result.append(file)
        }
    }
    return result
}

getSwiftFiles(exampleFiles)
//: This works until you want to look for other file extensions, or maybe files with no extension, or files starting with the string "Hello". To cover all these cases and more we need to make this solution general purpose.
//extension Array
//{
//    func filter(includeElement: Element -> Bool) -> [Element]
//    {
//        var result: [Element] = []
//        for x in self where includeElement(x)
//        {
//            result.append(x)
//        }
//        return result
//    }
//}

func getSwiftFiles2(files: [String]) -> [String]
{
    return files.filter { file in file.hasSuffix(".swift") }
}

getSwiftFiles2(exampleFiles)
//: ## Example of Map
let numbers = [1, 2, 3, 4, 5]
let largerNumbers = numbers.map { $0 + 1 }
largerNumbers
//: ## Example of Reduce
//: From Apple documentation, "Returns the result of repeatedly calling combine with an accumulated value initialized to initial and each element of self."
let sum = numbers.reduce(0) { result, x in result + x }
sum
//: Let's combine all these ideas to compute a fairly complex solution with a single line of code
struct City
{
    let name: String
    // pop. measured in 1000's of inhabitants
    let population: Int
}

let orlando = City(name: "Orlando", population: 262)
let winterPark = City(name: "Boston", population: 4180)
let nyc = City(name: "New York City", population: 8550)
let berlin = City(name: "Berlin", population: 3562)

let cities = [orlando, winterPark, nyc, berlin]
//: Let's print a list of all cities with over 1 million inhabitants, and also print the population figures for each.
extension City
{
    func cityByScalingPopulation() -> City
    {
        return City(name: name, population: population * 1000)
    }
}

let output = cities.filter { $0.population > 1000 }
    .map { $0.cityByScalingPopulation() }
    .reduce("City: Population") { result, c in
        return result + "\n" + "\(c.name): \(c.population)"}

print(output)
//: ### A note about using generics vs. the `Any` Type
//: Let's consider a simple example, that does nothing, and just returns the value passed in.
func noOp<T>(x: T) -> T
{
    return x
//    return 0 #2
}

noOp("Foo")

func noOpAny(x: Any) -> Any
{
    return x
//    return 0 #1
}

noOpAny("Bar")
//: ## Optionals
//let x: Int? = 3
//let y: Int? = nil
//let z: Int? = x + y

//: Can't perform addition on optional values. To fix we can create a function to add optionals after checking they are non-nil.

func addOptionals(optionalX: Int?, optionalY: Int?) -> Int?
{
    if let x = optionalX
    {
        if let y = optionalY
        {
            return x + y
        }
    }
    
    return nil
}
//: More efficiently, we can bind multiple optionals at once.
func addOptionals2(optionalX: Int?, optionalY: Int?) -> Int?
{
    if let x = optionalX, y = optionalY
    {
        return x + y
    }
    
    return nil
}
//: Even better than that, we can use guard to exit immediately if either value is nil
func addOptionals3(optionalX: Int?, optionalY: Int?) -> Int?
{
    guard let x = optionalX, y = optionalY else { return nil }
    return x + y
}
//: "The flatMap function checks whether an optional value is non-nil. If it is, we pass it on to the argument function f; if the optional argument is nil, the result is also nil."
//: Excerpt From: Chris Eidhof, "Functional Swift"
func addOptionals4(optionalX: Int?, optionalY: Int?) -> Int?
{
    return optionalX.flatMap { x in
        optionalY.flatMap { y in
            return x + y
        }
    }
}