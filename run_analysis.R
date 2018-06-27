library(dplyr)

# read in train data
Xtrain <- read.table("H:/Data Science specialization/Course3Week4_CourseProject/UCI HAR Dataset/train/X_train.txt")
Ytrain <- read.table("H:/Data Science specialization/Course3Week4_CourseProject/UCI HAR Dataset/train/y_train.txt")
Subtrain <- read.table("H:/Data Science specialization/Course3Week4_CourseProject/UCI HAR Dataset/train/subject_train.txt")

# read in test data
Xtest <- read.table("H:/Data Science specialization/Course3Week4_CourseProject/UCI HAR Dataset/test/X_test.txt")
Ytest <- read.table("H:/Data Science specialization/Course3Week4_CourseProject/UCI HAR Dataset/test/Y_test.txt")
Subtest <- read.table("H:/Data Science specialization/Course3Week4_CourseProject/UCI HAR Dataset/test/subject_test.txt")

# read in data description
varnames <- read.table("H:/Data Science specialization/Course3Week4_CourseProject/UCI HAR Dataset/features.txt")

# read in activity labels
activitylabels <- read.table("H:/Data Science specialization/Course3Week4_CourseProject/UCI HAR Dataset/activity_labels.txt")

# 1. Merge training and test data
Xtotal <- rbind(Xtrain, Xtest)
Ytotal <- rbind(Ytrain, Ytest)
Subtotal <- rbind(Subtrain, Subtest)

# 2. Extract measurements on the mean and standard deviation for each measurement.
selectvar <- varnames[grep("mean\\(\\)|std\\(\\)",varnames[,2]),]
Xtotal <- Xtotal[,selectvar[,1]]

# 3. Use descriptive activity names to name the activities
colnames(Ytotal) <- "activity"
Ytotal$activitylabel <- factor(Ytotal$activity, labels = as.character(activitylabels[,2]))
activitylabel <- Ytotal[,-1]

# 4. Appropriately label the data set with descriptive variable names.
colnames(Xtotal) <- varnames[selectvar[,1],2]

# 5. From the data set in step 4, creates a second, independent tidy data set with the averages
colnames(Subtotal) <- "subject"
total <- cbind(Xtotal, activitylabel, Subtotal)
totalmean <- total %>% group_by(activitylabel, subject) %>% summarize_all(funs(mean))
write.table(totalmean, file = "H:/Data Science specialization/Course3Week4_CourseProject/UCI HAR Dataset/tidy.txt", row.names = FALSE, col.names = TRUE)