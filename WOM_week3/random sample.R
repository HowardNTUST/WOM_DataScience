contact=read.csv('Book1.csv', stringsAsFactors = F)
contact=contact[grep('企管',contact$班級), ]
idx=sample(length(contact$id),3)
contact[idx,'姓名']


