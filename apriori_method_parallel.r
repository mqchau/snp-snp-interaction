
all_data <- read.csv("datafile/sample3.csv", head=FALSE, sep=",")

num_snp = ncol(all_data) - 1
num_sample = nrow(all_data)
case_control_col = ncol(all_data)
num_case = length(which(all_data[,case_control_col] == 1))
num_control = length(which(all_data[,case_control_col] == 0))

all_snp_single_correlation = matrix(nrow=num_snp,ncol=2)
for(snp_idx in 1:num_snp){
    all_snp_single_correlation[snp_idx,1] = length(which(all_data[,snp_idx] == 1 & 
                                  all_data[,case_control_col] == 1)) / num_case
    all_snp_single_correlation[snp_idx,2] = length(which(all_data[,snp_idx] == 1 & 
                                  all_data[,case_control_col] == 0)) / num_control
}

correlation_threshold = 0.80
passed_threshold_single = which(all_snp_single_correlation[,1] > correlation_threshold)

head(passed_threshold_single)

all_snp_combination = combn(passed_threshold_single, 2)
num_combination = ncol(all_snp_combination)

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

all_snp_comb_frame = data.frame(snp1=integer(num_combination),
                               snp2=integer(num_combination),
                               case_percent=double(num_combination),
                               control_percent=double(num_combination))

for (comb_idx in 1:ncol(all_snp_combination)){
    all_snp_comb_frame$snp1[comb_idx] = all_snp_combination[1,comb_idx]
    all_snp_comb_frame$snp2[comb_idx] = all_snp_combination[2,comb_idx]
    all_snp_comb_frame$case_percent[comb_idx] = percent_case_explained(all_snp_combination[1:2, comb_idx])
    all_snp_comb_frame$control_percent[comb_idx] = percent_control_explained(all_snp_combination[1:2, comb_idx])
}



probable_snp_comb_case = subset(all_snp_comb_frame, case_percent > correlation_threshold)
probable_snp_comb_control = subset(all_snp_comb_frame, control_percent > correlation_threshold)
probable_snp_comb_case
probable_snp_comb_control



