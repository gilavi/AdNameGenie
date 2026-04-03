import SwiftUI

struct BrandSection: View {
    @Bindable var form: FormState

    private let columns = Array(repeating: GridItem(.flexible(), spacing: DS.gridGap), count: 5)

    var body: some View {
        FormSection(number: 1, title: "Brand", funTitle: "Who's it for?") {
            LazyVGrid(columns: columns, spacing: DS.gridGap) {
                ForEach(Array(Brand.allCases.enumerated()), id: \.offset) { i, brand in
                    AnimatedEntry(delay: Double(i) * 0.045) {
                        BrandCard(
                            brand: brand,
                            isSelected: form.brand == brand,
                            action: {
                                if form.brand != brand {
                                    form.brand = brand
                                    form.onBrandChange()
                                }
                            }
                        )
                    }
                }
            }
        }
    }
}
