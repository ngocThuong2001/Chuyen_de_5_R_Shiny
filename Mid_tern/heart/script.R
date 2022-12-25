library(tidyverse) # import tidyverse library
data <- read.csv("D:/Thuong19it5/Chuyen_de/Mid_tern/dataset/heart.csv")

#Show 6 rows head
head(data)
#Show 6 rows tail
tail(data)
#show type of column
glimpse(data)
#total column
ncol(data)
#total row
nrow(data)

colnames(data) 

summary(data)

range(data$age)

###
data$group[data$age >= 27 & data$age < 40] <- 'A'
data$group[data$age >= 40 & data$age <= 55] <- 'B'
data$group[data$age > 55] <- 'C'

data
table(data$group)



#Data Transformation (Chuyển đổi dữ liệu)
data2 <- data %>%
  mutate(sex = if_else(sex == 1, "MALE", "FEMALE"),
         fbs = if_else(fbs == 1, ">120", "<=120"),
         exang = if_else(exang == 1, "YES" ,"NO"),
         cp = if_else(cp == 1, "đau thắt ngực không điển hình",
                      if_else(cp == 2, "không đau thắt ngực", "không có triệu chứng")),
         restecg = if_else(restecg == 0, "Bình thường",
                           if_else(restecg == 1, "Bất thường", "có thể xảy ra hoặc xác định")),
         slope = as.factor(slope),
         ca = as.factor(ca),
         thal = as.factor(thal),
         target = if_else(target == 1, "YES", "NO")]
  ) %>% 
  mutate_if(is.character, as.factor) %>% 
  dplyr::select(target, sex, fbs, exang, cp, restecg, slope, ca, thal, everything())

# Data Visualization (Trực quan hoá dữ liệu)
# Biểu đồ thanh cho mục tiêu (bệnh tim)
ggplot(data2, aes(x=data2$target, fill=data2$target))+
  geom_bar()+
  xlab("Bệnh tim")+
  ylab("Nhịp tim")+
  ggtitle("Có & Không có bệnh tim")+
  scale_fill_discrete(name= 'Bệnh tim', labels =c("Không có triệu chứng", "Có triệu chứng"))

prop.table(table(data2$target))

# đếm tần số cơn đau của từng khoảng độ tuổi
data2 %>%
  group_by(age) %>%
  count() %>%
  filter(n>10) %>%
  ggplot()+
  geom_col(aes(age, n), fill = 'green')+
  ggtitle("Bảng phân tích tuổi")+
  xlab("Tuổi")+
  ylab("Tần suất xuất hiện")

# so sánh huyết áp khi đau ngực theo giới tính
data2 %>%
  ggplot(aes(x=sex, y=trestbps))+
  geom_boxplot(fill ='purple')+
  xlab('Giới tính')+
  ylab('Huyết áp')+
  facet_grid(~cp)

data %>%
  ggplot(aes(x=sex, y=trestbps))+
  geom_boxplot(fill ='purple')+
  xlab('Giới tính')+
  ylab('Huyết áp')+
  facet_grid(~cp)

data2 %>%
  ggplot(aes(x=sex, y=chol))+
  geom_boxplot(fill ='orange')+
  xlab('sex')+
  ylab('cholesterol')+
  facet_grid(~cp)

#Correlation (Tương quan)
library(corrplot)
library(ggplot2)

cor_heart <- cor(data2[, 10:14])
cor_heart
corrplot(cor_heart, method ='square', type='upper')
??method
