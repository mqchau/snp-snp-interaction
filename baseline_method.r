library(foreach)
library(doParallel)
cl<-makeCluster(4)
registerDoParallel(cl)

all_data <- read.csv("datafile/sample2.csv", head=FALSE, sep=",")

num_snp = ncol(all_data) - 1
num_sample = nrow(all_data)
case_control_col = ncol(all_data)
num_case = length(which(all_data[,case_control_col] == 1))
num_control = length(which(all_data[,case_control_col] == 0))

all_snp_combination = combn(num_snp, 2)

percent_case_explained <- function(snp_comb){
    num_case_match = length(which(all_data[,snp_comb[1]] == 1 & 
                                  all_data[,snp_comb[2]] == 1 & 
                                  all_data[,case_control_col] == 1))
    return(num_case_match/num_case)
}

percent_control_explained <- function(snp_comb){
    num_case_match = length(which(all_data[,snp_comb[1]] == 1 & 
                                  all_data[,snp_comb[2]] == 1 & 
                                  all_data[,case_control_col] == 0))
    return(num_case_match/num_control)
}

num_combination = ncol(all_snp_combination)
all_snp_comb_frame = data.frame(snp1=integer(num_combination),
                               snp2=integer(num_combination),
                               case_percent=double(num_combination),
                               control_percent=double(num_combination))

all_snp_comb<-foreach(comb=all_snp_combination, .combine='cbind') %dopar%{
    snp1 = comb[1]
    snp2 = comb[2]
    case_percent = percent_case_explained(comb[1:2])
    control_percent = percent_control_explained(comb[1:2])
    c(snp1, snp2, case_percent, control_percent)
}
stopCluster(cl)

all_snp_comb = t(all_snp_comb)

explained_threshold = 0.80
probable_snp_comb_case = subset(all_snp_comb, all_snp_comb[,3] > explained_threshold)
probable_snp_comb_control = subset(all_snp_comb, all_snp_comb[,4] > explained_threshold)
probable_snp_comb_case
probable_snp_comb_control


