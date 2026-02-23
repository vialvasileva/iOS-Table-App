//
//  ViewController.swift
//  TableApp
//
//  Created by victoria on 23.02.2026.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Constants

    private enum Constant {
        enum ColorPreview {
            static let height: CGFloat = 200.0
            static let cornerRadius: CGFloat = 16.0
            static let horizontalOffset: CGFloat = 16.0
            static let topOffset: CGFloat = 60.0
        }
        enum Label {
            static let fontSize: CGFloat = 20.0
        }
        enum TableView {
            static let topOffset: CGFloat = 20.0
            static let rowHeight: CGFloat = 52.0
            static let cellIdentifier = "ColorCell"
        }
    }

    // MARK: - Models

    private struct ColorItem {
        let name: String
        let color: UIColor
    }

    // MARK: - Properties

    private let colorItems: [ColorItem] = [
        ColorItem(name: "Красный", color: .systemRed),
        ColorItem(name: "Синий", color: .systemBlue),
        ColorItem(name: "Зелёный", color: .systemGreen),
        ColorItem(name: "Оранжевый", color: .systemOrange),
        ColorItem(name: "Фиолетовый", color: .systemPurple),
        ColorItem(name: "Жёлтый", color: .systemYellow),
        ColorItem(name: "Розовый", color: .systemPink),
        ColorItem(name: "Бирюзовый", color: .systemTeal)
    ]

    // MARK: - Subviews

    private lazy var colorPreviewView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        view.layer.cornerRadius = Constant.ColorPreview.cornerRadius
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var colorNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Выберите цвет"
        label.font = .systemFont(ofSize: Constant.Label.fontSize, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constant.TableView.cellIdentifier)
        tableView.rowHeight = Constant.TableView.rowHeight
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    // MARK: - Methods

    private func configureView() {
        view.backgroundColor = .black

        view.addSubview(colorPreviewView)
        colorPreviewView.addSubview(colorNameLabel)
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            colorPreviewView.topAnchor.constraint(equalTo: view.topAnchor, constant: Constant.ColorPreview.topOffset),
            colorPreviewView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constant.ColorPreview.horizontalOffset),
            colorPreviewView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constant.ColorPreview.horizontalOffset),
            colorPreviewView.heightAnchor.constraint(equalToConstant: Constant.ColorPreview.height),

            colorNameLabel.centerXAnchor.constraint(equalTo: colorPreviewView.centerXAnchor),
            colorNameLabel.centerYAnchor.constraint(equalTo: colorPreviewView.centerYAnchor),

            tableView.topAnchor.constraint(equalTo: colorPreviewView.bottomAnchor, constant: Constant.TableView.topOffset),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func applyColor(_ item: ColorItem) {
        UIView.animate(withDuration: 0.3) {
            self.colorPreviewView.backgroundColor = item.color
        }
        colorNameLabel.text = item.name
    }
}

// MARK: - UITableViewDataSource

extension ViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        colorItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.TableView.cellIdentifier, for: indexPath)
        let item = colorItems[indexPath.row]

        var config = cell.defaultContentConfiguration()
        config.text = item.name
        config.image = colorCircleImage(for: item.color)
        cell.contentConfiguration = config

        return cell
    }
}

// MARK: - UITableViewDelegate

extension ViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = colorItems[indexPath.row]
        applyColor(item)
    }
}

// MARK: - Helpers

private extension ViewController {

    func colorCircleImage(for color: UIColor) -> UIImage? {
        let size = CGSize(width: 24, height: 24)
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { ctx in
            color.setFill()
            ctx.cgContext.fillEllipse(in: CGRect(origin: .zero, size: size))
        }
    }
}
