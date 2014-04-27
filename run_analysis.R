#Step 0: download and load the files
#the location of the zip file
#fileUrl <- "http://archive.ics.uci.edu/ml/machine-learning-databases/00240/UCI%20HAR%20Dataset.zip"
#download the file
#temp <- tempfile()
#download.file(fileUrl, destfile = temp)

#unzip the file and extract the data
#The code should have a file run_analysis.R in the main directory that can be run as long as the 
#Samsung data is in your working directory
testx <- read.table( "UCI HAR Dataset/test/X_test.txt")
testy <- read.table("UCI HAR Dataset/test/y_test.txt")
trainx <- read.table("UCI HAR Dataset/train/X_train.txt")
trainy <- read.table( "UCI HAR Dataset/train/y_train.txt")
labels <- read.table( "UCI HAR Dataset/activity_labels.txt")
features <- read.table("UCI HAR Dataset/features.txt")
trainsubject <- read.table("UCI HAR Dataset/train/subject_train.txt")
testsubject <- read.table("UCI HAR Dataset/test/subject_test.txt")


#Step 1: Merge the training and test data set
mergedx <- rbind(trainx, testx)
mergedy <- rbind(trainy, testy)
mergedsubject <- rbind(trainsubject, testsubject)

#Step 2: Extracts only the measurements on the mean and standard deviation for each measurement
toMatch <- c("mean\\(\\)", "std\\(\\)")
#use matches to store the indicies that is the mean or std
matches <- unique (grep(paste(toMatch,collapse="|"), features$V2))
matchesNames <- unique (grep(paste(toMatch,collapse="|"), features$V2, value = TRUE))
#subsetting the data set
afterSubsetx <- mergedx[ ,matches]

#Step 3: Uses descriptive activity names to name the activities in the data set
afterSubsetx$label <- mergedy$V1
afterSubsetx$label <- factor(afterSubsetx$label, levels = c(1, 2, 3, 4, 5, 6), labels = labels$V2)
afterSubsetx$subject <- mergedsubject$V1

#Step 4: Appropriately labels the data set with descriptive activity (column) names
columnNames <- append(matchesNames, c("label", "subject"))
colnames(afterSubsetx) <- columnNames

#Step 5: Creates a second, independent tidy data set with the average of each variable for each activity and each subject
s <- split(afterSubsetx, list(afterSubsetx$label, afterSubsetx$subject))
newTidyData <- sapply(s, function(x) colMeans(x[, matchesNames]))
write.table(newTidyData, file = "tidyData.txt", sep = "\t")



