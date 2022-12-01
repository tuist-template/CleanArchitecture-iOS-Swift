generate:
	tuist fetch
	tuist generate

clean:
	rm -rf **/*.xcodeproj
	rm -rf *.xcworkspace

reset:
	tuist clean
	rm -rf **/*.xcodeproj
	rm -rf *.xcworkspace

project:
	swift Scripts/generate_new_project.swift
