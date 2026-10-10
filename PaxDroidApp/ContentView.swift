import SwiftUI
import UniformTypeIdentifiers

struct GameItem: Identifiable {
    let id = UUID()
    let name: String
    let package: String
    let icon: String
    let fileURL: URL?
}

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("主頁", systemImage: "house")
                }
            
            SettingsView()
                .tabItem {
                    Label("設定", systemImage: "gear")
                }
        }
    }
}

struct HomeView: View {
    @State private var games: [GameItem] = []
    @State private var showingPicker = false
    @State private var selectedGame: GameItem?
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("遊戲庫")) {
                    if games.isEmpty {
                        Text("還沒有添加遊戲，點右上角 + 添加 APK")
                            .foregroundColor(.secondary)
                            .font(.caption)
                    }
                    ForEach(games) { game in
                        HStack(spacing: 12) {
                            Image(systemName: game.icon)
                                .font(.title2)
                                .foregroundColor(.blue)
                                .frame(width: 44, height: 44)
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(10)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(game.name)
                                    .font(.headline)
                                Text(game.package)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            NavigationLink(destination: APPLaunchView(game: game)) {
                                Text("運行")
                            }
                            .buttonStyle(.bordered)
                            .controlSize(.small)
                        }
                        .padding(.vertical, 4)
                    }
                    .onDelete { indexSet in
                        games.remove(atOffsets: indexSet)
                    }
                }
            }
            .navigationTitle("PaxDroid")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingPicker = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingPicker) {
                DocumentPicker { url in
                    if let url = url {
                        let name = url.deletingPathExtension().lastPathComponent
                        let newGame = GameItem(
                            name: name,
                            package: "com.example.\(name.lowercased())",
                            icon: "gamecontroller.fill",
                            fileURL: url
                        )
                        games.append(newGame)
                    }
                }
            }
        }
    }
}

struct DocumentPicker: UIViewControllerRepresentable {
    var onPick: (URL?) -> Void
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.data])
        picker.delegate = context.coordinator
        picker.allowsMultipleSelection = false
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(onPick: onPick)
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var onPick: (URL?) -> Void
        
        init(onPick: @escaping (URL?) -> Void) {
            self.onPick = onPick
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            onPick(urls.first)
        }
        
        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            onPick(nil)
        }
    }
}

struct SettingsView: View {
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("關於")) {
                    HStack {
                        Text("版本")
                        Spacer()
                        Text("1.0")
                            .foregroundColor(.secondary)
                    }
                    HStack {
                        Text("iOS 版本")
                        Spacer()
                        Text("15.0+")
                            .foregroundColor(.secondary)
                    }
                }
                
                Section(header: Text("翻譯層")) {
                    HStack {
                        Text("狀態")
                        Spacer()
                        Text("待接入")
                            .foregroundColor(.orange)
                    }
                }
                
                Section(header: Text("QEMU")) {
                    HStack {
                        Text("狀態")
                        Spacer()
                        Text("待加入")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("設定")
        }
    }
}

struct APPLaunchView: View {
    let game: GameItem
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: game.icon)
                .font(.system(size: 60))
                .foregroundColor(.blue)
            
            Text(game.name)
                .font(.title2)
                .fontWeight(.bold)
            
            Text(game.package)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Divider()
            
            Text("APP啟動")
                .font(.headline)
            
            Text("執行引擎待接入")
                .font(.caption)
                .foregroundColor(.orange)
            
            Spacer()
        }
        .padding()
        .navigationTitle("APP啟動")
        .navigationBarTitleDisplayMode(.inline)
    }
}
