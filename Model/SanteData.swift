import UIKit
import SQLite3

struct DB: ParserProtocol {
    
    static var db: OpaquePointer? = nil
        
    mutating func openDB() -> String {
        
        let lang = Locale.current.languageCode
        print("lang =", lang ?? "lang")
        var resource = "Sante"
        if lang == "fr" {
            resource += "fr"
        }
        
        guard let dbResourcePath = Bundle.main.path(forResource: resource, ofType: "db") else {
            return "FIG_VAM"
        }
        
        let fileManager = FileManager.default
        do {
            let dbPath = try fileManager.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent(resource + ".db")
                .path
            
            if !fileManager.fileExists(atPath: dbPath) {
                try fileManager.copyItem(atPath: dbResourcePath, toPath: dbPath)
            }
            
            guard sqlite3_open(dbPath, &DB.db) == SQLITE_OK else {
                print("error open DB \(Error.self)")
                return "error open DB on path =  \(dbPath)"}
            
            return "open DataBase done \(dbPath)"
            } catch {}

        return "error copy DB:\(dbResourcePath) in applicationSupportDirectory"
    }
    
    func getHTML(_ id: Int) -> String {
        
        var values = String()
        var str: OpaquePointer? = nil
        let query = "SELECT html FROM slides WHERE id = \(id)"
        
        if sqlite3_prepare_v2(DB.db, query, -1, &str, nil) == SQLITE_OK {
            print("query \(query) is DONE")
        } else {
            print("query \(query) is uncorrect")
        }
        
        if sqlite3_step(str) == SQLITE_ROW {
            let html = String(cString: sqlite3_column_text(str, 0))
            values = html
        } else {
            print("error get HTML from DataBase")
        }
        
        return values
    }
    
    //TODO: - make with Model
    func clearTxt(txt: inout String, id: Int, name: String, nameTopic: String)
        -> [(idSlide: Int , name: String, word: String, cnt: Int, listWord: String, nameTopic: String)]{
        
        let errorChar: Set<Character> = ["'"]
        txt.removeAll(where: { errorChar.contains($0) })
        
        // for french "’" don't remove
        let arrayTxt = txt.components(separatedBy:
            [",", " ", "!",".","?","\n","\r","(",")","*","_",
             "0","1","2","3","4","5","6","7","8","9", "+", "!",
             "=", ";", ":", "<", "&", "\"", "\\", "@", "[", "]",
             "{", "}", "«", "»", "-", "/", "·", "|", "#", " ",
             "“"])
            .filter({$0.count > 1})
        print("arrayTxt.count = ", arrayTxt.count)
        //        print(arrayTxt.sorted())
        
        var setTxt = Set<String>()
        arrayTxt.forEach{ setTxt.insert($0.lowercased()) }
        print("setTxt.count = ", setTxt.count)
        //        print(setTxt.sorted())
        
        // формируем массив кортежей для наполнения таблицы
        // сделать через модель
            var arrDict = [(idSlide: Int,
                            name: String,
                            word: String,
                            cnt: Int,
                            listWord: String,
                            nameTopic: String)]()
        
        setTxt.sorted().forEach{
            let word = $0
            
            var cnt = 1
            var listWord = word
            arrayTxt.forEach{
                if $0.contains(word) {
                    cnt += 1
                    listWord += " " + word
                }
            }
            
            let rec: (idSlide: Int , name: String, word: String, cnt: Int, listWord: String, nameTopic: String) = (id, name, $0, cnt, listWord, nameTopic)
            
            arrDict.append(rec)
        }
        
        print("arrDict.count = ", arrDict.count)
        
        // sort Dict on cnt, more to less
        arrDict = arrDict.sorted(by: { $0.3 > $1.3 } )
//        arrDict.forEach({print($0)})
        
        return arrDict
    }
}

// MARK: - delete records from table
extension DB {
    
    func deleteRecords(inTable:String, id: Int){
        
        var del: OpaquePointer? = nil
        let query = "DELETE FROM \(inTable) WHERE id_slide = '\(id)'"
        
        guard sqlite3_prepare_v2(DB.db, query, -1, &del, nil)==SQLITE_OK else {
            let errmsg = String(cString: sqlite3_errmsg(DB.db)!)
            print("error prepare delete: \(errmsg)")
            return
        }
        
        guard sqlite3_step(del) == SQLITE_DONE  else {
            let errmsg = String(cString: sqlite3_errmsg(DB.db)!)
            print("error delete: \(errmsg)")
            return
        }
        
        sqlite3_finalize(del)
        print(query)
    }
}

//MARK: - close DB
extension DB {
    func closeDB() {
        sqlite3_close(DB.db)
    }
}

// MARK: - CREATE VIRTUAL TABLE "slides_search"
extension DB {
    
    func insertSlideSearch(inTable: String,
                         arrDict: [(
        idSlide: Int,
        name: String,
        word: String,
        cnt: Int,
        listWord: String,
        nameTopic: String
        )]) {
        
        var insert: OpaquePointer? = nil
        
        arrDict.forEach{
            
            let insertString = """
            INSERT INTO \(inTable) (id_slide, name, word, cnt, list_word, name_topic) VALUES ('\($0.idSlide)', '\($0.name)', '\($0.word)', '\($0.cnt)', '\($0.listWord)', '\($0.nameTopic)');
            """
            guard sqlite3_prepare_v2(DB.db, insertString, -1, &insert, nil) == SQLITE_OK,
                sqlite3_step(insert) == SQLITE_DONE
                else {
                    let errmsg = String(cString: sqlite3_errmsg(DB.db)!)
                    print("error preparing insert: \(errmsg): for insert: ", insertString)
                    return
            }
            
        }
        
        sqlite3_finalize(insert)
    }
}

// MARK: - get dict for insert in table slides_search
/* var arrDict = [(
    idSlide: Int,
    name: String,
    word: String,
    cnt: Int,
    listWord: String
    nameTopic: String )]() */
extension DB {
    
    func createDict(_ id : Int) {
        
        var html = String()
        var nameTopic = String()
        var name = String()
        var str: OpaquePointer? = nil
        
        let query = """
        SELECT slides.name, html, slides_topic.name as name_topic
        FROM slides JOIN slides_topic
        on slides.id_topic = slides_topic.id
        WHERE slides.id = \(id)
        """
        
        if sqlite3_prepare_v2(DB.db, query, -1, &str, nil) == SQLITE_OK {
            //            print("query \(query) is DONE")
        } else {
            print("query \(query) is uncorrect")
        }
        
        if sqlite3_step(str) == SQLITE_ROW {
            name = String(cString: sqlite3_column_text(str, 0))
            html = String(cString: sqlite3_column_text(str, 1))
            nameTopic = String(cString: sqlite3_column_text(str, 2))
        } else {
            print("error get HTML from DataBase")
        }
        
//        sqlite3_finalize(str)
        
        // parser html
        var txt = parse(htmlString: html)
        
        let arrDict = clearTxt(txt: &txt, id: id, name: name, nameTopic: nameTopic)
        print("let arrDict = clearTxt(txt: &txt, id: id, name: name, nameTopic: nameTopic, arrDict.count = ", arrDict.count)
        
        deleteRecords(inTable: "slides_search", id: id)
        printWordCount(id)
        
        insertSlideSearch(inTable: "slides_search", arrDict: arrDict)
    
        sqlite3_finalize(str)
        return
    }
}

// MARK: - insert In Table question
extension DB {
    func insertInTable(inTable: String, values1: String, values2: String) {
        
        var insert: OpaquePointer? = nil
        let insertString = """
        INSERT INTO \(inTable) (question, date_question) VALUES (\(values1), \(values2));
        """
        guard sqlite3_prepare_v2(DB.db, insertString, -1, &insert, nil) == SQLITE_OK,
            sqlite3_step(insert) == SQLITE_DONE
            else {
                let errmsg = String(cString: sqlite3_errmsg(DB.db)!)
                print("error preparing insert: \(errmsg)")
                return
        }
        
        print("insert in table done")
        print(insertString)
        sqlite3_finalize(insert)
    }
}

//MARK: - get values from qustion table
extension DB {
    func selectFromTable(column: String, inTable: String, afterWhere: String) -> [String] {
        var values = [String]()
        var str: OpaquePointer? = nil
        var query = "SELECT \(column) FROM \(inTable) "
        
        if afterWhere != "" {
            query += "WHERE \(afterWhere)"
        }
        
        if sqlite3_prepare_v2(DB.db, query, -1, &str, nil) == SQLITE_OK {
            print("query \(query) is DONE")
        } else {
            print("query \(query) is uncorrect")
        }
        
        while (sqlite3_step(str)) == SQLITE_ROW {
            let value = String(cString: sqlite3_column_text(str, 0))
            values.append(value)
        }
        
        sqlite3_finalize(str)
        return values
    }
}

// MARK: - get records from table slides_search on request
extension DB {
        
    func searchSlides (_ req: String) -> [Slide] {
        
        var slides: [Slide] = []
        
        var str: OpaquePointer? = nil
        let query = req
        
        if sqlite3_prepare_v2(DB.db, query, -1, &str, nil) == SQLITE_OK {
            print("query \(query) is DONE")
        } else {
            print("query \(query) is uncorrect")
            let errmsg = String(cString: sqlite3_errmsg(DB.db)!)
            print("error preparing query: \(errmsg)")
        }
        
        while (sqlite3_step(str)) == SQLITE_ROW {
            
            let idSlide = Int(String(cString: sqlite3_column_text(str, 0))) ?? 0
            let nameTopic = String(cString: sqlite3_column_text(str, 1))
            let name = String(cString: sqlite3_column_text(str, 2))
            let count = String(cString: sqlite3_column_text(str, 3))
            let sum_count_word = String(cString: sqlite3_column_text(str, 4))
            let list = String(cString: sqlite3_column_text(str, 5))
            print(nameTopic + ": id=\(idSlide), " + name + "(" + count + ", " + sum_count_word + "): " + list)
    
            let slide = Slide(id: idSlide, name: name, nameTopic: nameTopic,
                              search: "(" + count + ", " + sum_count_word + "): " + list)
            slides.append(slide)
        }
        
        sqlite3_finalize(str)
        return slides
    }
    
    // MARK: - split search query on space
    func splittingSearch(_ query: String) -> [String] {
        
        var txt = query
//        let errorChar: Set<Character> = ["'"]
        let errorChar: Set<Character> = [
            "'", ",", "!", ".","?","\n","\r","(",")", "_",
            "0","1","2","3","4","5","6","7","8","9", "+", "!",
            "=", ";", ":", "<", "&", "\"", "\\", "@", "[", "]",
            "{", "}", "«", "»", "-", "/", "·", "|", "#", "“",
            "$", "^", "%"]

        txt.removeAll(where: { errorChar.contains($0) })
        
        // for french "’" don't remove
        let arrayTxt = txt.components(separatedBy: " ")
        
        print("arrayTxt.count = ", arrayTxt.count)
        print(arrayTxt)
        
        var setTxt = Set<String>()
        arrayTxt.forEach{ setTxt.insert($0.lowercased()) }
        print("setTxt.count = ", setTxt.count)
        print(setTxt)
        
        return arrayTxt
    }
    
    // MARK: - prepare sql query for search with multi words
    func prepareSearch(_ arrWord: [String]) -> String {
        
        var searchgSql = """
        SELECT id_slide, name_topic, name, count(), sum(count_word) as sum_count_word,
        GROUP_CONCAT(listWord || "(" || count_word || ")", "; ") as list from
        (
             select id_slide, name_topic, name, GROUP_CONCAT(word || "(" || cnt || ")", "; ") listWord, count(word) as count_word
             FROM
             (
                select * FROM slides_search WHERE list_word MATCH '\(arrWord[0])' ORDER BY rank
             )
             GROUP BY name
        """
        
        for index in 1..<arrWord.count{
            searchgSql += """
            \nUNION
            select id_slide, name_topic, name, GROUP_CONCAT(word || "(" || cnt || ")", "; ") listWord, count(word) as count_word
            FROM
            (
                select * FROM slides_search WHERE list_word MATCH '\(arrWord[index])' ORDER BY rank
            )
            GROUP BY name
            """
        }
        
        searchgSql += """
        )
        GROUP BY name HAVING count() = \(arrWord.count);
        """
        
        return searchgSql
    }
}

// MARK: get data image and video from blob
extension DB {
    
    func getDataFromBlob(_ id: Int) -> Data {
        
        var str: OpaquePointer? = nil
        var blob = Data()
        let query = "SELECT image from slides_image WHERE id = \(id);"
        
        if sqlite3_prepare_v2(DB.db, query, -1, &str, nil) == SQLITE_OK {
            print("prepare query \(query) is DONE")
        } else {
            print("prepare query \(query) is uncorrect")
            let errmsg = String(cString: sqlite3_errmsg(DB.db)!)
            print("error preparing query: \(errmsg)")
        }
        
        if sqlite3_step(str) == SQLITE_ROW {
                        
            if let dataBlob = sqlite3_column_blob(str, 0){
                let dataBlobLength = sqlite3_column_bytes(str, 0)
                blob = Data(bytes: dataBlob, count: Int(dataBlobLength))
                print("dataBlob: \n", dataBlob)
                print("dataBlobLength = ", dataBlobLength)
            }
        } else {
            print("query \(query) is uncorrect")
            let errmsg = String(cString: sqlite3_errmsg(DB.db)!)
            print("error run query: \(errmsg)")
        }
        
        sqlite3_finalize(str)
        return blob
    }
}

// MARK: get info about image or video for slide id
// SELECT id, name FROM slides_image where id_slide = 1;
extension DB {
    
    // TODO: - use Model
    func getInfoAboutDocForSlide(_ id: Int) -> [DocSlide] {
        
        var str: OpaquePointer? = nil
        var info = [DocSlide]()
        let query = "SELECT id, name from slides_image WHERE id_slide = \(id);"
        
        if sqlite3_prepare_v2(DB.db, query, -1, &str, nil) == SQLITE_OK {
            print("prepare query \(query) is DONE")
        } else {
            print("prepare query \(query) is uncorrect")
            let errmsg = String(cString: sqlite3_errmsg(DB.db)!)
            print("error preparing query: \(errmsg)")
        }
                
        while (sqlite3_step(str)) == SQLITE_ROW {
            let idDoc = Int(sqlite3_column_int(str, 0))
            let name = String(cString: sqlite3_column_text(str, 1))
            let docSlide = DocSlide(idSlide: id, idDoc: idDoc, nameDoc: name)
            info.append(docSlide)
        }
        
        sqlite3_finalize(str)
        return info
    }
}

// MARK: - get count word in table slides_search on id_slide
// SELECT count(word) as word_count FROM slides_search  WHERE id_slide = "7";
extension DB {
    
    func printWordCount(_ id: Int) {
        
        var str: OpaquePointer? = nil
        
        let query = "SELECT count(word) as word_count FROM slides_search  WHERE id_slide = '\(id)';"
        
        if sqlite3_prepare_v2(DB.db, query, -1, &str, nil) == SQLITE_OK {
        } else {
            print("query \(query) is uncorrect")
        }
        
        if sqlite3_step(str) == SQLITE_ROW {
            print("word_count with id = \(id): ", String(cString: sqlite3_column_text(str, 0)))
        } else {
            print("error get word_count with id = \(id)")
        }
        
        sqlite3_finalize(str)
    }
}

// MARK: get Topics from BD with number of slides to each
/*  select t.id, t.name, c.slides_count  from slides_topic as t JOIN (SELECT id_topic, count() as slides_count
    from slides GROUP by id_topic) as c on t.id = c.id_topic; */
 extension DB {
    
    func getTopics() -> [Topic] {
        
        var str: OpaquePointer? = nil
        var topics = [Topic]()
        let query = """
            select t.id, t.name, c.count_slides
            from slides_topic as t JOIN
                (SELECT id_topic, count() as count_slides
                from slides GROUP by id_topic) as c
            on t.id = c.id_topic
            ORDER by c.id_topic DESC;
            """
        
        if sqlite3_prepare_v2(DB.db, query, -1, &str, nil) == SQLITE_OK {
            print("prepare query \(query) is DONE")
        } else {
            print("prepare query \(query) is uncorrect")
            let errmsg = String(cString: sqlite3_errmsg(DB.db)!)
            print("error preparing query: \(errmsg)")
        }
                
        while (sqlite3_step(str)) == SQLITE_ROW {
            let id = Int(sqlite3_column_int(str, 0))
            let name = String(cString: sqlite3_column_text(str, 1))
            let countSlides = Int(sqlite3_column_int(str, 2))
            
            let topic = Topic(id: id, name: name, countSlides: countSlides)
            topics.append(topic)
        }
        
        sqlite3_finalize(str)
        return topics
    }
}

// MARK: - get list slides on Topic from DB, get id and name
extension DB {
    
    // SELECT id, name FROM slides where id_topic = 3;
    func getNameSlidesInTopic(_ idTopic: Int) -> [Slide] {
        
        var str: OpaquePointer? = nil
        var slides = [Slide]()
        let query = "SELECT id, name FROM slides where id_topic = \(idTopic);"
        
        if sqlite3_prepare_v2(DB.db, query, -1, &str, nil) == SQLITE_OK {
            print("prepare query \(query) is DONE")
        } else {
            print("prepare query \(query) is uncorrect")
            let errmsg = String(cString: sqlite3_errmsg(DB.db)!)
            print("error preparing query: \(errmsg)")
        }
                
        while (sqlite3_step(str)) == SQLITE_ROW {
            let id = Int(sqlite3_column_int(str, 0))
            let name = String(cString: sqlite3_column_text(str, 1))
            let slide = Slide(id: id, name: name)
            slides.append(slide)
        }
        
        sqlite3_finalize(str)
        return slides
    }
}

// MARK: - get data from table present with count slides
extension DB {
    
    func getPresentList() -> [Presentation] {
        
        var str: OpaquePointer? = nil
        var present = [Presentation]()
        
        let query = """
            SELECT p.id, p.name, s.name, s.image, c.count_slides, p.password, p.order_by
                from present as p join slides_image as s
                on p.id_image = s.id left join
                (SELECT id_present, count() as count_slides from slides_present
                GROUP by id_present) as c on c.id_present = p.id
                ORDER BY p.order_by;
            """
        
        if sqlite3_prepare_v2(DB.db, query, -1, &str, nil) == SQLITE_OK {
            print("prepare query \(query) is DONE")
        } else {
            print("prepare query \(query) is uncorrect")
            let errmsg = String(cString: sqlite3_errmsg(DB.db)!)
            print("error preparing query: \(errmsg)")
        }
                
        while (sqlite3_step(str)) == SQLITE_ROW {
            let id = Int(sqlite3_column_int(str, 0))
            let name = String(cString: sqlite3_column_text(str, 1))
            let nameImage = String(cString: sqlite3_column_text(str, 2))
            
            var blob = Data()
            if let dataBlob = sqlite3_column_blob(str, 3){
                let dataBlobLength = sqlite3_column_bytes(str, 3)
                blob = Data(bytes: dataBlob, count: Int(dataBlobLength))
                print("dataBlob: \n", dataBlob)
                print("dataBlobLength = ", dataBlobLength)
            }
            let imageSource = UIImage(data: blob)
            
            let countSlides = Int(sqlite3_column_int(str, 4))
            let pass = String(cString: sqlite3_column_text(str, 5))
            let order_by = Int(sqlite3_column_int(str, 6))
            
            let presentationLogo = Presentation(id: id, image: nameImage, text: name, imageSource: imageSource, countSlides: countSlides, pass: pass, order_by: order_by)
            present.append(presentationLogo)
        }
        
        sqlite3_finalize(str)
        return present
    }
}

// MARK: - get list topic's with count of slides on Presentation
extension DB {
    
    func getTopicsOnPresent(_ idPresent: Int) -> [Topic]{
        
        var str: OpaquePointer? = nil
        var topics = [Topic]()
        let query = """
            SELECT id_topic, name_topic, count() as count_slide FROM
                (
                SELECT s.id,  s.id_topic, t.name as name_topic
                from slides_present as p JOIN slides as s
                on p.id_slide = s.id
                JOIN slides_topic as t on s.id_topic = t.id
                where p.id_present = \(idPresent)
                )
            GROUP BY id_topic;
            """
        
        if sqlite3_prepare_v2(DB.db, query, -1, &str, nil) == SQLITE_OK {
            print("prepare query \(query) is DONE")
        } else {
            print("prepare query \(query) is uncorrect")
            let errmsg = String(cString: sqlite3_errmsg(DB.db)!)
            print("error preparing query: \(errmsg)")
        }
                
        while (sqlite3_step(str)) == SQLITE_ROW {
            let idTopic = Int(sqlite3_column_int(str, 0))
            let nameTopic = String(cString: sqlite3_column_text(str, 1))
            let countSlides = Int(sqlite3_column_int(str, 2))
            
            let topic = Topic(id: idTopic, name: nameTopic, countSlides: countSlides)
            topics.append(topic)
        }
        
        sqlite3_finalize(str)
        return topics
    }
}

// MARK: - get list slides in Topic on Present from DB, get id, name, description, icon
extension DB {
    
    func getListSlidesInTopicOnPresent(idPresent: Int, idTopic: Int) -> [Slide] {
        
        var str: OpaquePointer? = nil
        var slides = [Slide]()
        let query = """
            SELECT s.id, s.name, s.description, s.icon, t.name as name_topic
            FROM slides as s JOIN slides_topic as t
                on s.id_topic = t.id
            WHERE s.id in
            (
                SELECT s.id as id_slide
                from slides_present as p JOIN slides as s on p.id_slide = s.id
                JOIN slides_topic as t on s.id_topic = t.id
                where p.id_present = \(idPresent) and s.id_topic = \(idTopic)
            );
            """
 
        if sqlite3_prepare_v2(DB.db, query, -1, &str, nil) == SQLITE_OK {
            print("prepare query \(query) is DONE")
        } else {
            print("prepare query \(query) is uncorrect")
            let errmsg = String(cString: sqlite3_errmsg(DB.db)!)
            print("error preparing query: \(errmsg)")
        }
                
        while (sqlite3_step(str)) == SQLITE_ROW {
            let id = Int(sqlite3_column_int(str, 0))
            let name = String(cString: sqlite3_column_text(str, 1))
            let description = String(cString: sqlite3_column_text(str, 2))

            var blob = Data()
            if let dataBlob = sqlite3_column_blob(str, 3){
                let dataBlobLength = sqlite3_column_bytes(str, 3)
                blob = Data(bytes: dataBlob, count: Int(dataBlobLength))
                print("dataBlob: \n", dataBlob)
                print("dataBlobLength = ", dataBlobLength)
            }
            let imageSource = UIImage(data: blob) ?? UIImage()
            
            let nameTopic = String(cString: sqlite3_column_text(str, 4))
            
            let slide = Slide(id, name: name, description: description, icon: imageSource, nameTopic: nameTopic)
            slides.append(slide)
        }
        
        sqlite3_finalize(str)
        return slides
    }
}

// MARK: - get list slides in Topic for Library from DB, get id, name, description, icon
//  SELECT id, name, description, icon FROM slides WHERE id_topic = 16;
extension DB {
    
    func getListSlidesForLibrary(_ idTopic: Int) -> [Slide] {
        
        var str: OpaquePointer? = nil
        var slides = [Slide]()
        let query =
            "SELECT id, name, description, icon FROM slides WHERE id_topic = \(idTopic);"
 
        if sqlite3_prepare_v2(DB.db, query, -1, &str, nil) == SQLITE_OK {
            print("prepare query \(query) is DONE")
        } else {
            print("prepare query \(query) is uncorrect")
            let errmsg = String(cString: sqlite3_errmsg(DB.db)!)
            print("error preparing query: \(errmsg)")
        }
                
        while (sqlite3_step(str)) == SQLITE_ROW {
            let id = Int(sqlite3_column_int(str, 0))
            let name = String(cString: sqlite3_column_text(str, 1))
            let description = String(cString: sqlite3_column_text(str, 2))

            var blob = Data()
            if let dataBlob = sqlite3_column_blob(str, 3){
                let dataBlobLength = sqlite3_column_bytes(str, 3)
                blob = Data(bytes: dataBlob, count: Int(dataBlobLength))
                print("dataBlob: \n", dataBlob)
                print("dataBlobLength = ", dataBlobLength)
            }
            let imageSource = UIImage(data: blob) ?? UIImage()
                        
            let slide = Slide(id, name: name, description: description, icon: imageSource)
            slides.append(slide)
        }
        
        sqlite3_finalize(str)
        return slides
    }
}

// MARK: - get list slides in Presentation from DB, get id, name
//extension DB {
//
//    func getListSlidesOnPresent(_ idPresent: Int) -> [Slide] {
//
//        var str: OpaquePointer? = nil
//        var slides = [Slide]()
//        let query = """
//            SELECT s.id, s.name
//            FROM slides as s JOIN slides_present as p
//                on s.id = p.id_slide
//                WHERE p.id_present = \(idPresent)
//                ORDER BY p.order_by;
//            """
//
//        if sqlite3_prepare_v2(DB.db, query, -1, &str, nil) == SQLITE_OK {
//            print("prepare query \(query) is DONE")
//        } else {
//            print("prepare query \(query) is uncorrect")
//            let errmsg = String(cString: sqlite3_errmsg(DB.db)!)
//            print("error preparing query: \(errmsg)")
//        }
//
//        let orderInt = 0
//
//        while (sqlite3_step(str)) == SQLITE_ROW {
//            let id = Int(sqlite3_column_int(str, 0))
//            let name = String(cString: sqlite3_column_text(str, 1))
//            let order = String(orderInt)
//            let slide = Slide(id, name: name, order: order)
//            slides.append(slide)
//        }
//
//        sqlite3_finalize(str)
//        return slides
//    }
//}

// MARK: - gettting slide info from DB on id: name, description, icon for show in result of the search
extension DB {
    
    func getSlideInfo(_ idSlide: Int) -> Slide {
        
        var str: OpaquePointer? = nil
        var slide : Slide!
        
        let query = "SELECT name, description, icon FROM slides WHERE id = \(idSlide);"
        
        if sqlite3_prepare_v2(DB.db, query, -1, &str, nil) == SQLITE_OK {
            print("prepare query \(query) is DONE")
        } else {
            print("prepare query \(query) is uncorrect")
            let errmsg = String(cString: sqlite3_errmsg(DB.db)!)
            print("error preparing query: \(errmsg)")
        }
        
        if sqlite3_step(str) == SQLITE_ROW {
            let name = String(cString: sqlite3_column_text(str, 0))
            let description = String(cString: sqlite3_column_text(str, 1))
            
            var blob = Data()
            if let dataBlob = sqlite3_column_blob(str, 2){
                let dataBlobLength = sqlite3_column_bytes(str, 2)
                blob = Data(bytes: dataBlob, count: Int(dataBlobLength))
                print("dataBlob: \n", dataBlob)
                print("dataBlobLength = ", dataBlobLength)
            }
            
            let imageSource = UIImage(data: blob) ?? UIImage()
            slide = Slide(idSlide, name: name, description: description, icon: imageSource)
        } else {
            print("error get info form slide with id = \(idSlide)")
        }

        sqlite3_finalize(str)
        return slide
    }
}


// MARK: - get list slides for Video line from DB, get id, name, description, icon
extension DB {
    
    func getListSlidesForVideoLine() -> [Slide] {
        
        var str: OpaquePointer? = nil
        var slides = [Slide]()
        let query = """
            SELECT s.id, s.name, s.description, s.icon
            FROM slides as s WHERE s.type = 1;
            """
 
        if sqlite3_prepare_v2(DB.db, query, -1, &str, nil) == SQLITE_OK {
            print("prepare query \(query) is DONE")
        } else {
            print("prepare query \(query) is uncorrect")
            let errmsg = String(cString: sqlite3_errmsg(DB.db)!)
            print("error preparing query: \(errmsg)")
        }
                
        while (sqlite3_step(str)) == SQLITE_ROW {
            let id = Int(sqlite3_column_int(str, 0))
            let name = String(cString: sqlite3_column_text(str, 1))
            let description = String(cString: sqlite3_column_text(str, 2))

            var blob = Data()
            if let dataBlob = sqlite3_column_blob(str, 3){
                let dataBlobLength = sqlite3_column_bytes(str, 3)
                blob = Data(bytes: dataBlob, count: Int(dataBlobLength))
                print("dataBlob: \n", dataBlob)
                print("dataBlobLength = ", dataBlobLength)
            }
            let image = UIImage(data: blob) ?? UIImage()
                        
            let slide = Slide(id, name: name, description: description, icon: image)
            slides.append(slide)
        }
        
        sqlite3_finalize(str)
        return slides
    }
}

// MARK: - change order in list present
extension DB {
    
    func updateListPresentOnOrder(_ id: Int, order_by: Int) {
        
        var update: OpaquePointer? = nil
        let updateString = "UPDATE present SET order_by = \(order_by) where iD = \(id);"
        
        guard sqlite3_prepare_v2(DB.db, updateString, -1, &update, nil) == SQLITE_OK,
            sqlite3_step(update) == SQLITE_DONE else {
                let errmsg = String(cString: sqlite3_errmsg(DB.db)!)
                print("error preparing update: \(errmsg)")
                return
        }
        print("update done:", updateString)
        
        sqlite3_finalize(update)
    }
}


//MARK: - get list report
extension DB {
    //SELECT id, name, meet_day FROM report ;
    func getListReports() -> [LeftReport] {
        
        var str: OpaquePointer? = nil
        var reports = [LeftReport]()
        let query = """
               select id, presentation_name, meet_day from report;
               """
        
        if sqlite3_prepare_v2(DB.db, query, -1, &str, nil) == SQLITE_OK {
            print("prepare query \(query) is DONE")
        } else {
            print("prepare query \(query) is uncorrect")
            let errmsg = String(cString: sqlite3_errmsg(DB.db)!)
            print("error preparing query: \(errmsg)")
        }
        
        while (sqlite3_step(str)) == SQLITE_ROW {
            let id = Int(sqlite3_column_int(str, 0))
            let name = String(cString: sqlite3_column_text(str, 1))
            let meetDay = String(cString: sqlite3_column_text(str, 2))
            
            
            
            let report = LeftReport(id: id, name: name, meetDay: meetDay)
            reports.append(report)
        }
        return reports
    }
    
    func getListReports(_ isSend: Bool) -> [LeftReport] {
        
        var str: OpaquePointer? = nil
        var reports = [LeftReport]()
        var query = """
               select id, presentation_name, meet_day from report where send = 0 AND user_email = "12345678"
               """
        if isSend {
            query = """
            select id, presentation_name, meet_day from report where send = 1 AND user_email = "\(User.shared.email)"
            """
        } else {
            query = """
            select id, presentation_name, meet_day from report where send = 0 AND user_email = "\(User.shared.email)"
            """
        }
        
        if sqlite3_prepare_v2(DB.db, query, -1, &str, nil) == SQLITE_OK {
            print("prepare query \(query) is DONE")
        } else {
            print("prepare query \(query) is uncorrect")
            let errmsg = String(cString: sqlite3_errmsg(DB.db)!)
            print("error preparing query: \(errmsg)")
        }
        
        while (sqlite3_step(str)) == SQLITE_ROW {
            let id = Int(sqlite3_column_int(str, 0))
            let name = String(cString: sqlite3_column_text(str, 1))
            let meetDay = String(cString: sqlite3_column_text(str, 2))
            
            
            
            let report = LeftReport(id: id, name: name, meetDay: meetDay)
            reports.append(report)
        }
        return reports
    }
}

//MARK: - get report for right table view
extension DB {
    //select country, city, count_people, id_meat_type, comment FROM report WHERE id = 1;
    func getRightTBReports(_ id: Int) -> RightReport? {
        var str: OpaquePointer? = nil
        
        let query = """
               select country, city, count_people, id_meet_type, comment FROM report WHERE id = \(id);
               """
        
        if sqlite3_prepare_v2(DB.db, query, -1, &str, nil) == SQLITE_OK {
            print("prepare query \(query) is DONE")
        } else {
            print("prepare query \(query) is uncorrect")
            let errmsg = String(cString: sqlite3_errmsg(DB.db)!)
            print("error preparing query: \(errmsg)")
            return nil
        }
        
        var country = ""
        var city = ""
        var countPeople = -1
        var meetType = -1
        var comment = ""
        
        if sqlite3_step(str) == SQLITE_ROW {
            country = String(cString: sqlite3_column_text(str, 0))
            city = String(cString: sqlite3_column_text(str, 1))
            countPeople = Int(sqlite3_column_int(str, 2))
            meetType =  Int(sqlite3_column_int(str, 3))
            comment = String(cString: sqlite3_column_text(str, 4))
        } else {
            print("error")
            return nil
        }
        return RightReport(id: id, country: country, city: city, countPeople: countPeople, visitType: meetType, comment: comment)
    }
}


//MARK: - update report
extension DB {
    //UPDATE report
    //SET country = "country123", city = "city123", count_people = "123", id_meat_type = "5", comment = "comment123"
    //WHERE id = 1;
    func updateReport(_ newReport: RightReport) {
        var updateStatement: OpaquePointer? = nil
        let query = """
            UPDATE report
        SET country = "\(newReport.country)", city = "\(newReport.city)", count_people = "\(newReport.countPeople)", id_meet_type = "\(newReport.visitType)", comment = "\(newReport.comment)"
        WHERE id = \(newReport.id);
        """
        
        if sqlite3_prepare_v2(DB.db, query, -1, &updateStatement, nil) == SQLITE_OK {
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Successfully updated row.")
            } else {
                print("Could not update row.")
            }
        } else {
            print("UPDATE statement could not be prepared")
        }
        sqlite3_finalize(updateStatement)
    }
}

//MARK: - update report send
extension DB{
//    UPDATE report
//    SET send = 0
//    WHERE id = 1;
    func sendReport(_ id: Int) {
        var updateStatement: OpaquePointer? = nil
        let query = """
           UPDATE report
            SET send = 1
            WHERE id = \(id);
        """
        
        if sqlite3_prepare_v2(DB.db, query, -1, &updateStatement, nil) == SQLITE_OK {
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Successfully updated row.")
            } else {
                print("Could not update row.")
            }
        } else {
            print("UPDATE statement could not be prepared")
        }
        sqlite3_finalize(updateStatement)
    }
}

//MARK: - get images for report
extension DB {
    //SELECT image01, image02, image03 FROM report WHERE id = 1;
    func getImagesForReport(_ id: Int) -> [UIImage?] {
        var str: OpaquePointer? = nil
        
        let query = """
               SELECT image01, image02, image03 FROM report WHERE id = \(id);
               """
        
        if sqlite3_prepare_v2(DB.db, query, -1, &str, nil) == SQLITE_OK {
            print("prepare query \(query) is DONE")
        } else {
            print("prepare query \(query) is uncorrect")
            let errmsg = String(cString: sqlite3_errmsg(DB.db)!)
            print("error preparing query: \(errmsg)")
        }
        
        var images = [UIImage?]()
        
        if sqlite3_step(str) == SQLITE_ROW {
            for i in 0..<3 {
                var blob = Data()
                if let dataBlob = sqlite3_column_blob(str, Int32(i)){
                    let dataBlobLength = sqlite3_column_bytes(str, Int32(i))
                    blob = Data(bytes: dataBlob, count: Int(dataBlobLength))
                    print("dataBlob: \n", dataBlob)
                    print("dataBlobLength = ", dataBlobLength)
                    images.append(UIImage(data: blob))
                }
            }
        } else {
            print("error")
        }
        sqlite3_finalize(str)
        return images
    }
}

//MARK: - updates image for report
extension DB {
    func updateImageForReport(_ id: Int, _ images: [UIImage?]) {
        var updateStatement: OpaquePointer? = nil
        let query = "UPDATE report SET image01 = ?, image02 = ?, image03 = ? WHERE id = \(id);"



        if sqlite3_prepare_v2(DB.db, query, -1, &updateStatement, nil) == SQLITE_OK {
            for i in 0..<3 {
                if let image = images[i] {
                    if let data = image.pngData() as NSData? {
                        sqlite3_bind_blob(updateStatement, Int32(i + 1), data.bytes, Int32(data.length), nil)
                    }
                }
            }
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Successfully updated row.")
            } else {
                print("Could not update row.")
            }
        } else {
            print("UPDATE statement could not be prepared")
        }
        sqlite3_finalize(updateStatement)
    }
}

//MARK: -insert into report
extension DB {
    func insertReport(_ report: RightReport) {
        var updateStatement: OpaquePointer? = nil
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let result = formatter.string(from: date)
        let query = """
        INSERT INTO report(presentation_name, meet_day, count_people, id_meet_type, country, city, comment, send, user_email)
        VALUES ("\(report.presentationName ?? "default insert name")", "\(result)", \(report.countPeople), \(report.visitType),"\(report.country)", "\(report.city)", "\(report.comment)", 0, "\(User.shared.email)")
        """
        
        if sqlite3_prepare_v2(DB.db, query, -1, &updateStatement, nil) == SQLITE_OK {
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Successfully updated row.")
            } else {
                print("Could not update row.")
            }
        } else {
            print("UPDATE statement could not be prepared")
        }
        sqlite3_finalize(updateStatement)
    }
}

//MARK: -get last update report id
extension DB {
    func getLastUpdateId() -> Int? {
        var str: OpaquePointer? = nil
        
        let query = """
        select last_insert_rowid()
        """
        
        if sqlite3_prepare_v2(DB.db, query, -1, &str, nil) == SQLITE_OK {
            print("prepare query \(query) is DONE")
        } else {
            print("prepare query \(query) is uncorrect")
            let errmsg = String(cString: sqlite3_errmsg(DB.db)!)
            print("error preparing query: \(errmsg)")
            return nil
        }
        
        var id = 0
        
        if sqlite3_step(str) == SQLITE_ROW {
            id = Int(sqlite3_column_int(str, 0))
        } else {
            print("error")
            return nil
        }
        
        return id
    }
}


// MARK: - get list slides in Presentation from DB, get id, name, sound
extension DB {
    
    func getListSlidesOnPresent(_ idPresent: Int) -> [Slide] {
        
        var str: OpaquePointer? = nil
        var slides = [Slide]()
        let query = """
            SELECT s.id, s.name, ss.sound
            FROM  slides as s
                JOIN slides_present as p
                    on s.id = p.id_slide
                LEFT JOIN slides_sound as ss
                    on s.id_sound = ss.id
                WHERE p.id_present = \(idPresent)
                ORDER BY p.order_by;
            """
 
        if sqlite3_prepare_v2(DB.db, query, -1, &str, nil) == SQLITE_OK {
            print("prepare query \(query) is DONE")
        } else {
            print("prepare query \(query) is uncorrect")
            let errmsg = String(cString: sqlite3_errmsg(DB.db)!)
            print("error preparing query: \(errmsg)")
        }
    
        while (sqlite3_step(str)) == SQLITE_ROW {
            let id = Int(sqlite3_column_int(str, 0))
            let name = String(cString: sqlite3_column_text(str, 1))
            
            var blob = Data()
            if let dataBlob = sqlite3_column_blob(str, 2){
                let dataBlobLength = sqlite3_column_bytes(str, 2)
                blob = Data(bytes: dataBlob, count: Int(dataBlobLength))
                print("dataBlob: \n", dataBlob)
                print("dataBlobLength = ", dataBlobLength)
            }

            
            let slide = Slide(id, name: name, order: "0", sound: blob)
            slides.append(slide)
        }
        
        sqlite3_finalize(str)
        return slides
    }
}
