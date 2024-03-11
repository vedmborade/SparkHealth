//
//  Calendar.swift
//  HealthAPP
//
//  Created by Ved Borade on 3/4/24.
//

import SwiftUI
import FSCalendar

struct Calendar: View {
    var body: some View {
        CalendarView()
    }
}

struct CalendarView: UIViewRepresentable {
    @State private var selectedDate: Date?
    @State private var showNotePopup: Bool = false
    @State private var notes: String = ""
    
    typealias UIViewType = FSCalendar

    func makeUIView(context: Context) -> FSCalendar {
        let calendar = FSCalendar()
        calendar.delegate = context.coordinator
        calendar.appearance.todayColor = UIColor.systemBlue
        calendar.appearance.selectionColor = UIColor.systemGreen
        return calendar
    }

    func updateUIView(_ uiView: FSCalendar, context: Context) {
        // Update the calendar if needed
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, FSCalendarDelegate {
        var parent: CalendarView

        init(_ parent: CalendarView) {
            self.parent = parent
        }

        func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
            parent.selectedDate = date
            parent.showNotePopup.toggle()
        }
    }
}

struct NotePopupView: View {
    @Binding var showNotePopup: Bool
    @Binding var notes: String

    var body: some View {
        VStack {
            Text("Add Note")
                .font(.title)
                .padding()
            
            // Add your note input field here
            TextField("Enter your note", text: $notes)
                .padding()
            
            Button("Save") {
                // Handle saving the note
                showNotePopup.toggle()
            }
            .padding()
        }
        .background(Color.white)
        .cornerRadius(10)
        .padding()
    }
}

struct Calendar_Previews: PreviewProvider {
    static var previews: some View {
        Calendar()
    }
}
