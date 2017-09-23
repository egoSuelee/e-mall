import UIKit

class NavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UINavigationBar.appearance().barTintColor = UIColor.white;
        // 设置naviBar背景图片
        //UINavigationBar.appearance().setBackgroundImage(UIImage.init(), for: UIBarMetrics.default)
        //UINavigationBar.appearance().shadowImage = UIImage()
        
        // 设置title的字体及颜色
        let textAttr =  [NSFontAttributeName: UIFont.systemFont(ofSize: 18.0), NSForegroundColorAttributeName: UIColor.appNavBarTitleColor()]
        UINavigationBar.appearance().titleTextAttributes = textAttr
        self.interactivePopGestureRecognizer?.delegate = nil
        self.navigationBar.isTranslucent = false
    }
    
    // MARK: - 拦截push控制器
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if self.viewControllers.count < 1 {
            
        } else {
            viewController.hidesBottomBarWhenPushed = true
            viewController.navigationItem.leftBarButtonItem = setBackBarButtonItem()
        }
        super.pushViewController(viewController, animated: true)
    }
    
    
    // MARK: - private method
    func setBackBarButtonItem() -> UIBarButtonItem {
        let backButton = UIButton.init(type: .custom)
        backButton.setImage(UIImage(named: "hlm_back_icon"), for: .normal)
        backButton.sizeToFit()
        backButton.frame.size = CGSize(width: 30, height: 30)
        backButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        backButton.addTarget(self, action: #selector(NavigationController.backClick), for: .touchUpInside)
        return UIBarButtonItem.init(customView: backButton)
    }
    /// MARK: - 返回
    func backClick() {
        self.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
