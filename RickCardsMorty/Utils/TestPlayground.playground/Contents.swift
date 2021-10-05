import PlaygroundSupport
import Foundation

struct Item : Codable {
    var id:Int
    var name:String
    var date:Date?
}

var jsonString = "{\"id\":1 , \"name\":\"Rick\" , \"date\": \"2017-12-01\"}"

let dateFormatter = DateFormatter()
dateFormatter.dateFormat = "yyyy-MM-dd"

let decoder = JSONDecoder()
decoder.dateDecodingStrategy = .formatted(dateFormatter)
var item = try decoder.decode(Item.self, from: jsonString.data(using: .utf8)!)

import Combine

let _ = Just(5) //Simple publisher
    .map { value -> String in //Transformation pipeline
        return "a String of \(value)"
    }
    .sink { transformedValue in //Subscriber
        print("The end value is \(transformedValue)")
    }

let _ = Future<Int,Error> //Simple publisher handling error
{ promise in
    promise(.success(20))  //Emiting future value success
    //promise(.failure(NSError(domain: "", code: 20, userInfo: nil)))  //Emiting an error
}.catch { _ in //Pipeline in case of error promise(.failure)
    Just(0)
}.map { result -> String in  //Transformation pipeline
    return "a String of \(result)"
}
.sink { transformedValue in
    print("The end value is \(transformedValue)")
}


var url = "https://rickandmortyapi.com/api/episode/1"
url.split(separator: "/").last

let ids = [1,2,3]
print(ids.description)
