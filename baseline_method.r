
time_execution <- function(sample_idx){
    sample_name = sprintf("datafile/sample%d.csv", sample_idx)
    all_data <- read.csv(sample_name, head=FALSE, sep=",")

    # start timing after reading all data into memory
    ptm <- proc.time()

    num_snp = ncol(all_data)
    num_case = nrow(all_data)

    all_snp_combination = combn(num_snp, 2)

    percent_case_explained <- function(snp_comb){
        num_case_match = length(which(all_data[,snp_comb[1]] == 1 & 
                                      all_data[,snp_comb[2]] == 1))
        return(num_case_match/num_case)
    }

    num_combination = ncol(all_snp_combination)
    all_snp_comb_frame = data.frame(snp1=integer(num_combination),
                                   snp2=integer(num_combination),
                                   case_percent=double(num_combination))

    for (comb_idx in 1:ncol(all_snp_combination)){
        all_snp_comb_frame$snp1[comb_idx] = all_snp_combination[1,comb_idx]
        all_snp_comb_frame$snp2[comb_idx] = all_snp_combination[2,comb_idx]
        all_snp_comb_frame$case_percent[comb_idx] = percent_case_explained(all_snp_combination[1:2, comb_idx])
    }

    explained_threshold = 0.80
    probable_snp_comb_case = subset(all_snp_comb_frame, case_percent > explained_threshold)


    return(proc.time() - ptm)
}

print(time_execution(2))

