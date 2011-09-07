# This will only work in scripts with active support included to provide DateTime#utc?
DateTime.send(:include, BurlapIso8601)
