import XCTest
@testable import Armstrong

final class ArmstrongTests: XCTestCase {
	func testScreenCode() throws {
		let screen = Screen(
			id: .init(),
			name: "Test",
			initVariables: .makeDefault(),
			initActions: .makeDefault(),
			subscreens: [],
			content: .init([
				MakeableLabel.text(.string("Hello, World!"))
			])
		)
		
		let code = """
		struct TestView: View {
			init() {
			
			}
			var body: some View {
				[
					Text("\\("Hello, World!")")
						.font(.system(size: 18).weight(.regular))
						.if(false) { $0.italic() }
						.foregroundStyle(Color(hex: "000000FF"))
				]
			}
		}
		"""
		
		XCTAssertEqual(screen.sanitisedRepresentation, code.sanitisedRepresentation)
	}
}

extension CodeRepresentable {
	var sanitisedRepresentation: String {
		codeRepresentation
			.sanitisedRepresentation
	}
}

extension String {
	var sanitisedRepresentation: String {
		components(separatedBy: "\n")
			.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
			.filter { $0.count > 0 }
			.joined(separator: "\n")
	}
}
