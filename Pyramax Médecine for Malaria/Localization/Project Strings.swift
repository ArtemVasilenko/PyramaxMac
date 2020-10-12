import Foundation

// MARK: - words in project
struct ReportsWords {
    static var shared: ReportsWords = ReportsWords()
    //main
    let hello = NSLocalizedString("Hello", comment: "")
    //libraries
    let libraries = NSLocalizedString("Libraries", comment: "")
    //reports
    let attentionReport10 = NSLocalizedString("Attention! You are approaching the maximum number of pending tasks. After reaching 10, access to presentations will be blocked.", comment: "")
    let attentionReport = NSLocalizedString("Attention! Access to viewing presentations is blocked. You need to fill out reports to continue working with the system.", comment: "")
    let later = NSLocalizedString("Later", comment: "")
    let sent = NSLocalizedString("Sent", comment: "")
    let country = NSLocalizedString("Country", comment: "")
    let city = NSLocalizedString("City", comment: "")
    let numberOfPeople = NSLocalizedString("Number of people", comment: "")
    let typeEvent = NSLocalizedString("Type of event", comment: "")
    let comment = NSLocalizedString("Comment", comment: "")
    let hcpVisite = NSLocalizedString("HCP visite", comment: "")
    let pharmacyVisit = NSLocalizedString("Pharmacy visit", comment: "")
    let roundTable = NSLocalizedString("Round table", comment: "")
    let clinicaMeeting = NSLocalizedString("Clinical meeting", comment: "")
    let others = NSLocalizedString("Others", comment: "")
    
    let error = NSLocalizedString("Error", comment: "")
    let errorCountry = NSLocalizedString("Please enter country name", comment: "")
    let errorCity = NSLocalizedString("Please enter city name", comment: "")
    let errorPeopleCount = NSLocalizedString("Please enter count people", comment: "")
    let errorPhoto = NSLocalizedString("Please add photo", comment: "")
    let ok = NSLocalizedString("Ok", comment: "")
    let reports = NSLocalizedString("Reports", comment: "")
}

// MARK: - start presentation alert
struct StartPresentationAlert {
    static var shared: StartPresentationAlert = StartPresentationAlert()
    let startPresentation = NSLocalizedString("Start", comment: "")
    let realyStart = NSLocalizedString("Are you realy want to start presentation mode?", comment: "")
    let startNow = NSLocalizedString("Start now", comment: "")
    let later = NSLocalizedString("Later", comment: "")
}

// MARK: - lock presentation alert
struct LockPresentationAlert {
    static var shared: LockPresentationAlert = LockPresentationAlert()
    let lockedPresentation = NSLocalizedString("Locked presentation", comment: "")
    let enterPassword = NSLocalizedString("to proceed enter password", comment: "")
    let ok = NSLocalizedString("OK", comment: "")
    let cancel = NSLocalizedString("Cancel", comment: "")
}

// MARK: - close app alert
struct CloseAppAlert {
    static var shared: CloseAppAlert = CloseAppAlert()
    let quit = NSLocalizedString("Quit", comment: "")
    let realeLeaveApp = NSLocalizedString("Are you realy want to leave presentation mode?", comment: "")
    let yes = NSLocalizedString("Yes", comment: "")
    let no = NSLocalizedString("No", comment: "")
}

// MARK: - fill reports alert
struct FillReportsAlert {
    static var shared: FillReportsAlert = FillReportsAlert()
    let sorry = NSLocalizedString("Sorry", comment: "")
    let presentNotAvailable = NSLocalizedString("Presentations are not available, please fill in pending reports", comment: "")
    let ok = NSLocalizedString("Ok", comment: "")
}

// MARK: - remember password alert
struct RememberPasswordAlert {
    static var shared: RememberPasswordAlert = RememberPasswordAlert()
    let wrongEmail = NSLocalizedString("Wrong email", comment: "")
    let enterCorrectEmail = NSLocalizedString("Enter the correct email", comment: "")
    let ok = NSLocalizedString("OK", comment: "")
    let done = NSLocalizedString("Done", comment: "")
    let resetPassword = NSLocalizedString("Open your email and reset password", comment: "")
}

//MARK: - invalid username or password
struct InvalidNameOrPassword {
    static var shared: InvalidNameOrPassword = InvalidNameOrPassword()
    let invalidValues = NSLocalizedString("Invalid Password or Username", comment: "")
    let pleaseCorrect = NSLocalizedString("Please correct your information and try again", comment: "")
    let ok = NSLocalizedString("OK", comment: "")
}

//MARK: - Intetnet error
struct InternetError {
    static var shared: InternetError = InternetError()
    let sorry = NSLocalizedString("Sorryan", comment: "")
    let internetIsNotConected = NSLocalizedString("Internet is not connected", comment: "")
    let ok = NSLocalizedString("OK", comment: "")
}

// MARK: - Policy alert
struct PolicyAlert {
    static var shared: PolicyAlert = PolicyAlert()
    let title = NSLocalizedString("Privacy Policy", comment: "")
    let mess = NSLocalizedString("Lorem Ipsum", comment: "")
    let accept = NSLocalizedString("I accept", comment: "")
}

//MARK: - Registration alerts
struct RegistrationAlert {
    static var shared: RegistrationAlert = RegistrationAlert()
    let error = NSLocalizedString("Error", comment: "")
    let emailIncorrect = NSLocalizedString("Email incorrect", comment: "")
    let passwordIncorrect = NSLocalizedString("Password incorrect", comment: "")
    let passwordDoNotMatch = NSLocalizedString("Passwords do not match", comment: "")
    let ok = NSLocalizedString("OK", comment: "")
    let avatar = NSLocalizedString("Please add photo", comment: "")
}
