
time_execution <- function(sample_idx){
    sample_name = sprintf("datafile/sample%d.csv", sample_idx)
    all_data <- read.csv(sample_name, head=FALSE, sep=",")

    # start timing after reading all data into memory
    ptm <- proc.time()


    num_snp = ncol(all_data)
    num_case = nrow(all_data)

    all_snp_single_correlation = matrix(nrow=num_snp,ncol=1)
    for(snp_idx in 1:num_snp){
        all_snp_single_correlation[snp_idx,1] = length(which(all_data[,snp_idx] == 1)) / num_case
    }

    correlation_threshold = 0.80
    passed_threshold_single = which(all_snp_single_correlation[,1] > correlation_threshold)

    head(passed_threshold_single)

    all_snp_combination = combn(passed_threshold_single, 2)
    num_combination = ncol(all_snp_combination)

    percent_case_explained <- function(snp_comb){
        num_case_match = length(which(all_data[,snp_comb[1]] == 1 & 
                                      all_data[,snp_comb[2]] == 1))
        return(num_case_match/num_case)
    }

    all_snp_comb_frame = data.frame(snp1=integer(num_combination),
                                   snp2=integer(num_combination),
                                   case_percent=double(num_combination))

    for (comb_idx in 1:ncol(all_snp_combination)){
        all_snp_comb_frame$snp1[comb_idx] = all_snp_combination[1,comb_idx]
        all_snp_comb_frame$snp2[comb_idx] = all_snp_combination[2,comb_idx]
        all_snp_comb_frame$case_percent[comb_idx] = percent_case_explained(all_snp_combination[1:2, comb_idx])
    }



    probable_snp_comb_case = subset(all_snp_comb_frame, case_percent > correlation_threshold)
    
    return(proc.time() - ptm)
}

for(i in 1:4){
    print(time_execution(i))
}


