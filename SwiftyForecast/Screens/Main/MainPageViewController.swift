//
//  MainPageViewController.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 6/10/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import UIKit

final class MainPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    private let feedbackGenerator: UIImpactFeedbackGenerator
    private var weatherViewControllers: [WeatherViewController]
    private(set) var currentIndex: Int

    init(
        currentIndex: Int,
        feedbackGenerator: UIImpactFeedbackGenerator
    ) {
        self.weatherViewControllers = []
        self.currentIndex = currentIndex
        self.feedbackGenerator = feedbackGenerator
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        dataSource = self
    }

    func set(_ viewControllers: [WeatherViewController]) {
        weatherViewControllers = viewControllers
    }

    func transition(at index: Int) {
        setViewControllers(
            [weatherViewControllers[index]],
            direction: .forward,
            animated: false,
            completion: { isCompleted in
                if isCompleted {
                    self.currentIndex = index
                }
            }
        )
    }

    func firstPage() -> WeatherViewController {
        guard let initialViewController = weatherViewControllers.first else {
            fatalError()
        }

        return initialViewController
    }
}

// MARK: - UIPageViewControllerDataSource
extension MainPageViewController {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard let viewController = viewController as? WeatherViewController else { return nil }

        guard let pageIndex = weatherViewControllers.firstIndex(where: {
            $0.viewModel.compoundKey == viewController.viewModel.compoundKey
        }) else {
            return nil
        }

        let previousIndex = pageIndex - 1
        let firstPageIndex = 0
        guard previousIndex >= firstPageIndex else {
            return nil
        }

        return weatherViewControllers[previousIndex]
    }

    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard let viewController = viewController as? WeatherViewController else { return nil }

        guard let pageIndex = weatherViewControllers.firstIndex(where: {
            $0.viewModel.compoundKey == viewController.viewModel.compoundKey
        }) else {
            return nil
        }

        let nextIndex = pageIndex + 1
        let lastPageIndex = weatherViewControllers.count - 1
        guard nextIndex <= lastPageIndex else {
            return nil
        }

        return weatherViewControllers[nextIndex]
    }

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        weatherViewControllers.count
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        currentIndex
    }
}

// MARK: - UIPageViewControllerDelegate
extension MainPageViewController {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {

        if completed,
           let visibleViewController = pageViewController.viewControllers?.first as? WeatherViewController,
           let currentIndex = weatherViewControllers.firstIndex(of: visibleViewController) {
            self.currentIndex = currentIndex
            triggerPageTransitionCompletedFeedback()
        }
    }

    private func triggerPageTransitionCompletedFeedback() {
        feedbackGenerator.prepare()
        feedbackGenerator.impactOccurred()
    }
}
