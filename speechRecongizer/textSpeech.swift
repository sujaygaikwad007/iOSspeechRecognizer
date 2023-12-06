import UIKit
import AVFoundation
import DropDown

class textSpeech: UIViewController, AVSpeechSynthesizerDelegate  {
    
    @IBOutlet weak var uiViewMenu: UIView!
    @IBOutlet weak var textDataTable: UITableView!
    @IBOutlet weak var selectLanguage: UIButton!
    @IBOutlet weak var dispLangLbl: UILabel!
    @IBOutlet var mainView: UIView!
    
    
    let dropDown = DropDown()
    let speechSythesizer = AVSpeechSynthesizer()
    var selectedLangCode : String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addGradientBackground()
        
        
        speechSythesizer.delegate = self
        textDataTable.dataSource = self
        textDataTable.delegate = self
        textDataTable.register(UINib(nibName: "TextSpeechTVC", bundle: .none), forCellReuseIdentifier: "TextSpeechTVC")
        
        
        selectLanguage.layer.cornerRadius = 20.0
        
        uiViewMenu.isHidden = true
        dispLangLbl.isHidden = true
        
        
    }
    
    
    @IBAction func selectLangBtn(_ sender: UIButton) {
        
        dropDownMenu()
        uiViewMenu.isHidden = false
        dispLangLbl.isHidden = false
        
    }
    
    func dropDownMenu(){
        
        dropDown.dataSource = ["en-US", "es-ES", "fr-FR", "de-DE","hi-IN","zh-CN","ja-JP","ru-RU","th-TH"]
        dropDown.anchorView = uiViewMenu
        dropDown.bottomOffset = CGPoint(x: 0, y: uiViewMenu.frame.size.height)
        dropDown.show()
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected Item:---- \(item) at index:---- \(index)")
            self.selectedLangCode = item
            
            
        }
        
    }
    
    func speakText(_ text: String){
        
        guard let languageCode = selectedLangCode,
              let voice = AVSpeechSynthesisVoice(language: languageCode) else {
                  print("Voice are not availabel------ \(selectedLangCode ?? "nil")")
                  
                  return
              }
        dispLangLbl.text = "Language Selected \(selectedLangCode ?? "nil")"
        
        let speechUtterance = AVSpeechUtterance(string: text)
        speechUtterance.voice = voice
        speechSythesizer.speak(speechUtterance)
        
        
        print("speaking:\(text) in \(languageCode)")
    }
    
    func addGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = mainView.bounds
        gradientLayer.colors = [UIColor.systemMint.cgColor, UIColor.systemTeal.cgColor]
        gradientLayer.locations = [0.3, 1.0]
        mainView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    
}


extension textSpeech: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //        let cell = textDataTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        //        cell.textLabel?.text = tableData[indexPath.row]
        
    
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TextSpeechTVC", for: indexPath) as! TextSpeechTVC
        cell.lblSpeech.text = tableData[indexPath.row]
        cell.mainView.layer.borderWidth = 1
        cell.mainView.layer.borderColor = UIColor.lightGray.cgColor
        
        //cell.layer.cornerRadius = 20
        
        
        //cell.backgroundColor = UIColor.systemCyan
        //cell.layer.borderWidth = 1
        // cell.layer.borderColor = UIColor.black.cgColor
        //cell.clipsToBounds = true
        
        let textLabel = UILabel(frame: CGRect(x: 16, y: 8, width: tableView.bounds.width - 32, height: 24))
        textLabel.font = UIFont.boldSystemFont(ofSize: 14)
        cell.addSubview(textLabel)
        
        
        
        
        
        let speakBtn = UIButton(type: .system)
//        speakBtn.setTitle("Speak", for: .normal)
        speakBtn.setImage(UIImage(systemName: "mic.fill"), for: .normal)

        speakBtn.frame = CGRect(x: Int(tableView.bounds.width) - 80, y: 30, width: 64, height: 24)
        speakBtn.addTarget(self, action: #selector(speakBtnTapped(_ :)), for: .touchUpInside)
        speakBtn.tag = indexPath.row
        cell.addSubview(speakBtn)
        
        
        
        
        
        return cell
    }
    
    @objc func speakBtnTapped(_ sender: UIButton){
        
        let selectedText = tableData[sender.tag]
        print("selectedText from table:--- \(selectedText)")
        speakText(selectedText)
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
    
    
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        let selectedText = tableData[indexPath.row]
//        print("selectedText from table:--- \(selectedText)")
//        speakText(selectedText)
//
//    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        cell.selectedBackgroundView = bgColorView
    }
    
    
    
}
