import UIKit
import CoreData
import RealmSwift
import IQKeyboardManager

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        migrate()

        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().isEnableAutoToolbar = false

        print(Realm.Configuration.defaultConfiguration.fileURL)
        
        //初期データを入れるコード
        let defaultRealmPath = Realm.Configuration.defaultConfiguration.fileURL!
        let bundleRealmPath = Bundle.main.url(forResource: "default", withExtension: "realm")
        if !FileManager.default.fileExists(atPath: defaultRealmPath.path) {
            do {
              try FileManager.default.copyItem(at: bundleRealmPath!, to: defaultRealmPath)
            } catch let error {
                print("error: \(error)")
              }
          }

        return true
    }

    func migrate(){
//            let config = Realm.Configuration(
//                // Set the new schema version. This must be greater than the previously used
//                // version (if you've never set a schema version before, the version is 0).
//                schemaVersion: 1,
//
//                // Set the block which will be called automatically when opening a Realm with
//                // a schema version lower than the one set above
//                migrationBlock: { migration, oldSchemaVersion in
//
//                    if oldSchemaVersion < 1 {
//                        migration.enumerateObjects(ofType: Textbook.className()) { oldObject, newObject in
//                            newObject?["dateCreated"] = Date()
//                        }
//                    }
//            }
//            )
//            Realm.Configuration.defaultConfiguration = config
        }
}




