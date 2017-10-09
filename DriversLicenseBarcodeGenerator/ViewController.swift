import Cocoa
import CoreImage

class ViewController: NSViewController {
    @IBOutlet var imageView: NSImageView!
    
    @IBOutlet var firstNameTextField: NSTextField!
    @IBOutlet var middleNameTextField: NSTextField!
    @IBOutlet var lastNameTextField: NSTextField!
    
    @IBOutlet var address1TextField: NSTextField!
    @IBOutlet var cityTextField: NSTextField!
    @IBOutlet var zipTextField: NSTextField!
    @IBOutlet var statePopupButton: NSPopUpButton!
    
    @IBOutlet var expirationDatePicker: NSDatePicker!
    @IBOutlet var issueDatePicker: NSDatePicker!
    @IBOutlet var dateOfBirthDatePicker: NSDatePicker!
    @IBOutlet var sexPopupButton: NSPopUpButton!
    @IBOutlet var eyeColor: NSPopUpButton!
    @IBOutlet var customerIDNumberTextField: NSTextField!
    
    @IBOutlet var jurisdictionSpecificVehicleClassTextField: NSTextField!
    @IBOutlet var jurisdictionSpecificEndorsementCodesTextField: NSTextField!
    @IBOutlet var jurisdictionSpecificRestrictionCodesTextField: NSTextField!
    @IBOutlet var physicalDescriptionHeightTextField: NSTextField!
    
    let issuerIdentificationNumber = "636000" // TODO: Make dynamic
    let AAMVAVersionNumber = "09" // TODO: Make dynamic
    let jurisdictionVersionNumber = "00" // TODO: Make dynamic

    private var jurisdictionSpecificEndorsementCodes: String {
        return jurisdictionSpecificEndorsementCodesTextField.stringValue
    }
    
    private var jurisdictionSpecificRestrictionCodes: String {
        return jurisdictionSpecificEndorsementCodesTextField.stringValue
    }
    
    private var jurisdictionSpecificVehicleClass: String {
        return jurisdictionSpecificVehicleClassTextField.stringValue
    }
    
    private var documentExpirationDate: Date {
        return expirationDatePicker.dateValue
    }

    private var customerFamilyName: String {
        return lastNameTextField.stringValue;
    }
    
    private var customerFirstName: String {
        return firstNameTextField.stringValue
    }
    
    private var customerMiddleNames: [String] {
        return [middleNameTextField.stringValue]
    }
    
    private var documentIssueDate: Date {
        return issueDatePicker.dateValue;
    }

    private var dateOfBirth: Date {
        return dateOfBirthDatePicker.dateValue
    }

    private var physicalDescriptionSex: DataElementGender {
        return .Male // TODO: Get this from the picker
    }
    
    private var physicalDescriptionEyeColor: DataElementEyeColor {
        return .Hazel // TODO: Get this from the picker
    }
    
    private var physicalDescriptionHeight: Int {
        return physicalDescriptionHeightTextField.integerValue
    }

    private var addressStreet1: String {
        return address1TextField.stringValue;
    }
    
    private var addressCity: String {
        return cityTextField.stringValue
    }

    private var addressJurisdictionCode: String {
        return "OH" // TODO: How do you get the value of a popup?
    }

    private var addressPostalCode: String {
        return zipTextField.stringValue
    }
    
    private var customerIDNumber: String {
        return customerIDNumberTextField.stringValue
    }
    
    private var documentDiscriminator: String {
        return "1234567890123456789012345" // TODO: Create some kind of generator for this and populate a field in the UI w/ it initially
    }

    private var countryIdentification: DataElementCountryIdentificationCode {
        return .US // TODO
    }
    
    var dataElements:[Any] {
        return [
            DCA(jurisdictionSpecificVehicleClass),
            DCB(jurisdictionSpecificRestrictionCodes),
            DCD(jurisdictionSpecificEndorsementCodes),
            DBA(documentExpirationDate),
            DCS(customerFamilyName),
            DAC(customerFirstName),
            DAD(customerMiddleNames),
            DBD(documentIssueDate),
            DBB(dateOfBirth),
            DBC(physicalDescriptionSex),
            DAY(physicalDescriptionEyeColor),
            DAU(physicalDescriptionHeight),
            DAG(addressStreet1),
            DAI(addressCity),
            DAJ(addressJurisdictionCode),
            DAK(addressPostalCode),
            DAQ(customerIDNumber),
            DCF(documentDiscriminator),
            DCG(countryIdentification),
            DDE(.No), // TODO: This should be calculated inside of barcode
            DDF(.No), // TODO: This should be calculated inside of barcode
            DDG(.No), // TODO: This should be calculated inside of barcode
        ]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.wantsLayer = true
        imageView.layer?.backgroundColor = NSColor.gray.cgColor
    }

    // MARK: - Actions
    
    @IBAction func generate(sender: Any) {
        let barcode = Barcode(dataElements: dataElements, issuerIdentificationNumber: issuerIdentificationNumber, AAMVAVersionNumber: AAMVAVersionNumber, jurisdictionVersionNumber: jurisdictionVersionNumber)

        print(barcode)
        
        if let image = generatePDF417Barcode(from: barcode) {
            imageView.image = image

        }
    }

    // MARK: - Helpers
    
    func generatePDF417Barcode(from barcode: Barcode) -> NSImage? {
        if let filter = CIFilter(name: "CIPDF417BarcodeGenerator") {
            filter.setValue(barcode.data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                let cgImage = output.toCGImage()
                
                return NSImage(cgImage: cgImage!, size: NSSize(width: 500, height: 100))
            }
        }
        
        return nil
    }
 }

