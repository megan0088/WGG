//
//  WorkoutView.swift
//  WGG
//
//  Created by George Maximillian Theodore on 02/05/26.
//

import SwiftUI
import SwiftData

struct WorkoutView: View {
    
    let muscleGroups: [String] = [
        "All",
        "Chest",
        "Shoulders",
        "Back",
        "Arms",
        "Legs"
    ]
    
    @State private var search: String = ""
//    @State private var routines = Routine.dummyRoutine
    @Query private var routines: [Routine]
    @Query private var exerciseList: [Exercise]
    @State private var selectedFilter: String = "All"
    
    
    @State private var selectedExerciseIDs: Set<UUID> = []
    @State private var showSaveSheet: Bool = false
    @State private var newRoutineName: String = ""
//    @State private var newRoutineColor: Color = .red
//    let availableColors: [Color] = [.red, .orange, .yellow, .green, .blue, .purple, .pink]
    
    @Environment(WorkoutManager.self) private var manager
    @Environment(\.modelContext) private var modelContext
    
    @State private var navigateToLogSet: Bool = false
    
    
    var filteredExercises: [Exercise] {
        if selectedFilter == "All" {
            return exerciseList
        } else {
            return exerciseList.filter { exercise in
                exercise.muscleGroup == selectedFilter
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.background.ignoresSafeArea()
                
                ScrollView {
                    VStack (alignment: .leading) {
                        Text("Exercises")
                            .font(.title.bold())
                            .foregroundStyle(Color.primaryText)
                        
                        Text("What are we lifting today?")
                            .font(.headline)
                            .foregroundStyle(Color.primaryText.opacity(0.5))
                        
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundStyle(Color.primaryText.opacity(0.5))
                            
                            TextField(
                                "Search exercises here...",
                                text: $search,
                                prompt: Text("Search exercises here...").foregroundStyle(Color.primaryText.opacity(0.5))
                            )
                            .foregroundStyle(Color.primaryText)
                        }
                        .padding(10)
                        .background(Color.primaryText.opacity(0.1))
                        .cornerRadius(16)
                        .padding(.bottom, 20)
                        
                        VStack(alignment: .leading) {
                            Text("ROUTINES")
                                .font(Font.body.bold())
                                .foregroundStyle(Color.primaryText.opacity(0.5))
                            
                            
                            ForEach(routines) { routine in
                                RoutineCard(routine: routine) {
                                    manager.startWorkout(from: routine, context: modelContext)
                                    navigateToLogSet = true
                                }
                            }
                        }
                        .padding(.bottom, 20)
                        
                        VStack (spacing: 16) {
                            ScrollView (.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach (muscleGroups, id: \.self) { muscleGroup in
                                        
                                        let isActive = selectedFilter == muscleGroup
                                        
                                        Button{
                                            if selectedFilter == muscleGroup && muscleGroup != "All" {
                                                selectedFilter = "All"
                                            } else {
                                                selectedFilter = muscleGroup
                                            }
                                        } label: {
                                            Text(muscleGroup)
                                                .fontWeight(isActive ? .semibold : .regular)
                                                .foregroundStyle(isActive ? Color.background : Color.accent)
                                                .padding(8)
                                                .padding(.horizontal, 8)
                                                .background(isActive ? Color.accent : Color.background)
                                                .border(isActive ? Color.background : Color.accent.opacity(0.3), width: isActive ? 0 : 1)
                                        }
                                    }
                                }
                            }
                            
                            ForEach(filteredExercises) { exercise in
                                
                                let isSelected = selectedExerciseIDs.contains(exercise.id)
                                
                                ExerciseCard(exercise: exercise, isSelected: isSelected) {
                                    if isSelected {
                                        selectedExerciseIDs.remove(exercise.id)
                                    } else {
                                        selectedExerciseIDs.insert(exercise.id)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .safeAreaInset(edge: .bottom) {
                    if !selectedExerciseIDs.isEmpty {
                        Button{
                            showSaveSheet = true
                        } label: {
                            HStack {
                                Spacer()
                                Text("Save Routine · \(selectedExerciseIDs.count) \(selectedExerciseIDs.count > 1 ? "Exercises" : "Exercise")")
                                    .font(.headline)
                                    .foregroundStyle(Color.background)
                                Spacer()
                            }
                            .padding()
                            .background(Color.accent)
                            .cornerRadius(16)
                            .padding(.horizontal)
                            .shadow(color: Color.black.opacity(0.3), radius: 10, y: -5)
                        }
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
                .animation(.easeInOut, value: selectedExerciseIDs.isEmpty)
            }
            .navigationDestination(isPresented: $navigateToLogSet) {
                LogSetView()
            }
            .sheet(isPresented: $showSaveSheet) {
                VStack(alignment: .leading) {
                    Text("Save Routine")
                        .font(.title.bold())
                        .foregroundStyle(Color.primaryText)
                    Text("\(selectedExerciseIDs.count) \(selectedExerciseIDs.count > 1 ? "exercises" : "exercise") selected")
                        .font(.body)
                        .foregroundStyle(Color.primaryText.opacity(0.5))
                        .padding(.bottom, 8)
                    
                    TextField(
                        "Name",
                        text: $newRoutineName,
                        prompt: Text("e.g. My Pull Day").foregroundStyle(Color.primaryText.opacity(0.5))
                    )
                    .foregroundStyle(Color.primaryText)
                    .padding(16)
                    .background(Color.primaryText.opacity(0.1))
                    .cornerRadius(16)
                    .padding(.bottom, 8)
                    
                    //                VStack(alignment: .leading) {
                    //                    Text("THEME COLOR")
                    //                        .font(.caption)
                    //                        .foregroundColor(.gray)
                    //                    
                    //                    HStack(spacing: 12) {
                    //                        ForEach(availableColors, id: \.self) { color in
                    //                            
                    //                            let isSelected = newRoutineColor == color
                    //                            
                    //                            Circle()
                    //                                .fill(color)
                    //                                .frame(width: 40, height: 40)
                    //                            // Bikin ring kalau lagi dipilih
                    //                                .overlay(
                    //                                    Circle()
                    //                                        .stroke(Color.white, lineWidth: isSelected ? 3.0 : 0.0)
                    //                                        .padding(-4)
                    //                                )
                    //                                .onTapGesture {
                    //                                    newRoutineColor = color
                    //                                }
                    //                        }
                    //                    }
                    //                }
                    //                .padding(.bottom, 16)
                    
                    HStack {
                        Button {
                            // TODO: bikin logic save routine nya
                            let exercisesToSave = exerciseList.filter { selectedExerciseIDs.contains($0.id) }
                            
                            let newRoutine = Routine(title: newRoutineName, exercises: exercisesToSave)
                            
                            modelContext.insert(newRoutine)
                            
                            showSaveSheet.toggle()
                            
                            selectedExerciseIDs.removeAll()
                            newRoutineName = ""
                        } label: {
                            Text("Save")
                                .font(Font.body.bold())
                                .foregroundStyle(newRoutineName.isEmpty ? Color.white : Color.background)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(newRoutineName.isEmpty ? Color.gray : Color.accent)
                                .cornerRadius(16)
                                .disabled(newRoutineName.isEmpty)
                        }
                    }
                }
                .padding()
                .presentationDetents([.medium])
                .presentationBackground(Color.background)
            }
            .onAppear {
                // Cek apakah database exercise masih kosong?
                if exerciseList.isEmpty {
                    // 1. Masukkan semua Master Exercise ke database
                    for ex in Exercise.exerciseList {
                        modelContext.insert(ex)
                    }
                    
                    // 2. Masukkan Routine dummy bawaanmu ke database
                    //                for routine in Routine.dummyRoutine {
                    //                    modelContext.insert(routine)
                    //                }
                    
                    // 3. Paksa simpan
                    try? modelContext.save()
                }
            }
        }
    }
}

#Preview {
    WorkoutView()
        .environment(WorkoutManager())
        .modelContainer(for: [Routine.self, Exercise.self, Session.self, SessionExercise.self, SessionSet.self], inMemory: true)
}

