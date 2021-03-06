//
//  MGPlayerViewController.swift
//  MGDS_Swift
//
//  Created by i-Techsys.com on 17/1/19.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

class MGPlayerViewController: UIViewController {
    // MARK: - 属性
    // MARK: 自定义
    var live : MGHotModel!
    var ijplayer: IJKMediaPlayback!
    var playerView: UIView!
    fileprivate lazy var p918 = UIImageView(image: #imageLiteral(resourceName: "porsche"))
    
    // MARK: SB拖拽属性
    @IBOutlet weak var giftBtn: UIButton!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var imgBackground: UIImageView!
    
    // MARK: - 生命周期
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        // 1.默认模糊主播头像背景
        setBg()
        
        // 2.准备播放器
        setPlayerView()
        
        // 3.把按钮提升到view最前面
        bringBtnTofront()
    }
    
    //view加载完成后,开始播放视频
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        if !self.ijplayer.isPlaying() {
            ijplayer.prepareToPlay()
        } else {
            ijplayer.prepareToPlay()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if ((ijplayer) != nil) {
            ijplayer.shutdown()
            ijplayer.view.removeFromSuperview()
            ijplayer = nil
        }
//        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

// MARK: - setPlayerView
extension MGPlayerViewController  {
    func setPlayerView()  {
        //初始化一个空白容器view
        self.playerView = UIView(frame: MGScreenBounds)
        view.addSubview(self.playerView)
        
        
        //初始化IJ播放器的控制器和view
        ijplayer = IJKFFMoviePlayerController(contentURLString: live.flv!, with: nil)
        let pv = ijplayer.view!
        
        
        //将播放器view自适应后,加入容器
        pv.frame = playerView.bounds
        pv.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        playerView.insertSubview(pv, at: 1)
        ijplayer.scalingMode = .aspectFill
        
    }
}

// MARK: - 初始化的一些方法
extension MGPlayerViewController {
    
    func setBg()  {
        //头像
        let imgUrl = URL(string: live.bigpic!)
        imgBackground.kf.setImage(with: imgUrl, placeholder:  UIImage(named: "10"))
        
        let blurEffect = UIBlurEffect(style: .light)
        let effectView = UIVisualEffectView(effect: blurEffect)
        effectView.frame = imgBackground.bounds
        imgBackground.addSubview(effectView)
    }
    
    
    func bringBtnTofront()  {
        self.view.bringSubview(toFront: likeBtn)
        self.view.bringSubview(toFront: backBtn)
        self.view.bringSubview(toFront: giftBtn)
    }
}

// MARK: - Action
extension MGPlayerViewController {
    // 点击礼物🎁
    @IBAction func giftBtnTap(_ sender: UIButton) {
        let duration = 3.0
        
        
        p918.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        view.addSubview(p918)
        
        let widthP918:CGFloat = 240
        let heightP918:CGFloat = 120
        
        UIView.animate(withDuration: duration) {
            self.p918.frame =
                CGRect(x: self.view.center.x - widthP918/2, y: self.view.center.y - heightP918/2, width: widthP918, height: heightP918)
        }
        
        //主线程延时一个完整动画后,再让礼物图片逐渐透明,完全透明后从父视图移除
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            UIView.animate(withDuration: duration, animations: {
                self.p918.alpha = 0
                }, completion: { (completed) in
                    self.p918.removeFromSuperview()
            })
        }
        
        // 烟花 https://github.com/yagamis/emmitParticles
        let layerFw = CAEmitterLayer()
        view.layer.addSublayer(layerFw)
        emmitParticles(from: sender.center, emitter: layerFw, in: view)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration * 2) {
            layerFw.removeFromSuperlayer()
        }
    }
    
    @IBAction func goBack(_ sender: UIButton) {
//        ijplayer.shutdown()
        let _ = dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func like(_ sender: UIButton) {
        //爱心大小
        let heart = DMHeartFlyView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        
        //爱心的中心位置
        heart.center = CGPoint(x: likeBtn.frame.origin.x, y: likeBtn.frame.origin.y)
        
        view.addSubview(heart)
        heart.animate(in: view)
        
        
        //爱心按钮的 大小变化动画
        let btnAnime = CAKeyframeAnimation(keyPath: "transform.scale")
        btnAnime.values   = [1.0, 0.7, 0.5, 0.3, 0.5, 0.7, 1.0, 1.2, 1.4, 1.2, 1.0]
        btnAnime.keyTimes = [0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0]
        btnAnime.duration = 0.2
        sender.layer.add(btnAnime, forKey: "SHOW")
        
    }
}

