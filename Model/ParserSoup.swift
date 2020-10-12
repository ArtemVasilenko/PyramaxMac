import SwiftSoup

protocol ParserProtocol {
    func parse(htmlString: String, cssSelector: String) -> String
}

extension ParserProtocol {
    
    func parse(htmlString: String, cssSelector: String = "*") -> String {
        var items = String()
        var document: Document = Document.init("")
        
        do {
            document = try SwiftSoup.parse(htmlString)
        } catch let error {
            print("ERROR GET DOCUMENT \(error)")
        }
        
        do {
            let elements: Elements = try document.select(cssSelector)
            
            // делаем на N тегов
            var i = 0
            for element in elements {
                let text = try element.text()
                items += "\n" + text
                
                i += 1
                //                if i == 20 { break }
            }
            print("i = ", i)
            items = "i = \(i) \n" + items
            
        } catch let error {
            print("Error: \(error)")
        }
        
        return items
    }
}
