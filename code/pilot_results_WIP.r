# Use this code to evaluate worker performance based on pilot resul csvs
rm(list = ls())

# load supporting functions
source(file = "pilot_data_transformation_functions.r")


#---------------------------------------------------------------------#
# FOCUS ON A SINGLE CSV FILE CORRESPONDING TO A SINGLE TREATMENT
# PILOT, PAYMENT RATE = 0.25

# read in qualtric output csv
qualtric_data_path_0.25 = "../qualtric_data/20171028_qualtric_results_pilot_0.25.csv"
current_task_data_0.25 = get_current_task_data(qualtric_data_path_0.25)

#stats summary of accuracies over all questions
summarize_question_accuracy(current_task_data_0.25, allQ)

#evaluate accuracy per worker, return a table per worker
worker_perf_0.25 = evaluate_worker_perf(current_task_data_0.25, allQ)
worker_perf_0.25

#stats summary of accuracies over all workers
summarize_worker_perf(current_task_data_0.25, allQ)

#---------------------------------------------------------------------#
# FOCUS ON A SINGLE CSV FILE CORRESPONDING TO A SINGLE TREATMENT
# PILOT, PAYMENT RATE = 0.10

# read in qualtric output csv
qualtric_data_path_0.10 = "../qualtric_data/20171028_qualtric_results_pilot_0.10.csv"
current_task_data_0.10 = get_current_task_data(qualtric_data_path_0.10)

#stats summary of accuracies over all questions
summarize_question_accuracy(current_task_data_0.10, allQ)

#evaluate accuracy per worker, return a table per worker
worker_perf_0.10 = evaluate_worker_perf(current_task_data_0.10, allQ)
worker_perf_0.10

#stats summary of accuracies over all workers
summarize_worker_perf(current_task_data_0.10, allQ)

#---------------------------------------------------------------------#
# COMPARING TWO CSV FILES FROM DIFFERENT TREATMENTS

# TWO-SAMPLE T-TEST
# test if variance of the two groups are unequal
car::leveneTest(worker_perf_0.10$accuracy,worker_perf_0.25$accuracy,center=median)
# 2 sample independent t-test
t.test(worker_perf_0.10$accuracy,
       worker_perf_0.25$accuracy,
       alternative = "two.sided", var.equal = TRUE)

# REGRESSION
# pool the data from different treatments together
worker_perf_0.25$treatment = 0.25
worker_perf_0.10$treatment = 0.10
regr_table = rbind(worker_perf_0.10, worker_perf_0.25)
# our covariates are CQ1, CQ2_3, CQ3
# converting some data type of some covariates
regr_table$CQ1 = as.factor(regr_table$CQ1)
regr_table$CQ2_3 = as.numeric(regr_table$CQ2_3)
regr_table$CQ3 = as.factor(regr_table$CQ3)

regr1 = lm(accuracy ~ treatment, data = regr_table)
regr2 = lm(accuracy ~ treatment + CQ1 + CQ2_3 + CQ3, data = regr_table)
summary(regr1)
summary(regr2)
