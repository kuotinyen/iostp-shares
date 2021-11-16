//
//  PanelViewController.swift
//  PanelMap
//
//  Created by TK on 2021/11/16.
//

import UIKit
import SnapKit

protocol PanelContentScrollDelegate: AnyObject {
    func handleScrollViewWillBeginDragging(_ scrollView: UIScrollView)
    func handleScrollViewDidEndDragging(_ scrollView: UIScrollView)
    func handleScrollViewDidEndDecelerating(_ scrollView: UIScrollView)
}

protocol PanelContentProvider {
    var scrollDelegate: PanelContentScrollDelegate? { get }
}

class PanelViewController: UIViewController {
    private enum PanelState {
        case header
        case partial
        case expand
        
        var viewHeightRatio: CGFloat {
            switch self {
            case .header: return 0.2
            case .partial: return 0.5
            case .expand: return 1
            }
        }
    }
    
    private let backgroundView: UIView
    private let contentViewController: UIViewController
    
    private let panelView: UIView = {
        let view = UIView()
        view.directionalLayoutMargins = .init(top: 20, leading: .zero, bottom: .zero, trailing: .zero)
        view.backgroundColor = .gray
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true
        
        let dragView = UIView()
        dragView.backgroundColor = .lightGray
        dragView.layer.cornerRadius = 3
        dragView.clipsToBounds = true
        view.addSubview(dragView)
        dragView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(8)
            $0.size.equalTo(CGSize(width: 40, height: 3))
        }
        return view
    }()
    
    private var panelTopConstriant: Constraint!
    private var isPanelHeightReady: Bool = false
    private var panelState: PanelState = .partial
    private var panStartingPoint: CGFloat = .zero
    private var panPanelRecognizer: UIPanGestureRecognizer?
    
    init(backgroundView: UIView, contentViewController: UIViewController) {
        self.backgroundView = backgroundView
        self.contentViewController = contentViewController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(backgroundView)
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        view.addSubview(panelView)
        panelView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        let panPanelRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panPanel))
        panPanelRecognizer.delegate = self
        self.panelView.addGestureRecognizer(panPanelRecognizer)
        self.panPanelRecognizer = panPanelRecognizer
        
        addChild(contentViewController)
        contentViewController.didMove(toParent: self)
        panelView.addSubview(contentViewController.view)
        
        contentViewController.view.snp.makeConstraints {
            $0.top.equalTo(panelView.layoutMarginsGuide)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if !isPanelHeightReady {
            panelView.snp.makeConstraints {
                panelTopConstriant = $0.top.equalTo(view.snp.bottom).inset(view.heightUnderStatusBar * panelState.viewHeightRatio).constraint
            }
            isPanelHeightReady = true
        }
    }
    
    @objc func panPanel(_ recognizer: UIPanGestureRecognizer) {
        let point = recognizer.translation(in: recognizer.view?.superview)
        let velocity = recognizer.velocity(in: recognizer.view)
        
        switch recognizer.state {
        case .began:
            panStartingPoint = panelTopConstriant.value
        case .changed:
            guard abs(panStartingPoint + point.y) < view.heightUnderStatusBar * PanelState.expand.viewHeightRatio else { return }
            panelTopConstriant.value = panStartingPoint + point.y
        case .ended:
            let isPanDown = velocity.y > 0
            let isPanHard = abs(velocity.y) > 700
            
            switch panelState {
            case .header:
                showPanel(at: isPanDown ? .header : isPanHard ? .expand : .partial)
            case .partial:
                showPanel(at: isPanDown ? .header : .expand)
            case .expand:
                showPanel(at: isPanDown ? isPanHard ? .header : .partial : .expand)
            }
        default: break
        }
    }
    
    private func showPanel(at state: PanelState) {
        panelState = state
        panelTopConstriant.value = -(view.heightUnderStatusBar * state.viewHeightRatio)
        
        UIView.animate(withDuration: 0.25, delay: .zero, options: .curveEaseOut) {
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - UIGestureRecognizerDelegate

extension PanelViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
}

// MARK: - PanelContentScrollDelegate

extension PanelViewController: PanelContentScrollDelegate {
    func handleScrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        switch panelState {
        case .expand:
            let isPanDown = scrollView.panGestureRecognizer.velocity(in: scrollView).y >= 0
            let onScrollViewTop = scrollView.contentOffset.y <= 0
            
            if isPanDown && onScrollViewTop {
                panPanelRecognizer?.isEnabled = true
                scrollView.panGestureRecognizer.isEnabled = false
            } else {
                panPanelRecognizer?.isEnabled = false
                scrollView.panGestureRecognizer.isEnabled = true
            }
        case .header, .partial:
            panPanelRecognizer?.isEnabled = true
            scrollView.panGestureRecognizer.isEnabled = false
        }
    }
    
    func handleScrollViewDidEndDragging(_ scrollView: UIScrollView) {
        [panPanelRecognizer, scrollView.panGestureRecognizer].forEach {
            $0?.isEnabled = true
        }
    }
    
    func handleScrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        [panPanelRecognizer, scrollView.panGestureRecognizer].forEach {
            $0?.isEnabled = true
        }
    }
}
