## Favorite Modeling Methods I’ve Learned from ST558

Before I dive into my favorite method, let’s take a list at what methods
we’ve covered thus far.

Models/Methods: \* Regression Tree’s \* Classification Tree’s \*
Boosting \* Bagging \* RandomForest \* Simple Linear Regression \*
Multiple Linear Regression \* Logistic Regression \* k - Nearest
Neighbors \* Clustering \* Principal Components Analysis

I think my favorite would be logistic regression because of just how
useful answering Yes/No and evaluating the odds.

We’ll run this example using the Titanic Dataset to predict whether an
individual survived or not using some other variables we have.

``` r
titanicData <- read_csv("_Rmd/_datasets/titanic.csv") #assigning to different variable
```

    ## Rows: 1310 Columns: 14
    ## ── Column specification ──────────────────────────────────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## chr (7): name, sex, ticket, cabin, embarked, boat, home.dest
    ## dbl (7): pclass, survived, age, sibsp, parch, fare, body
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

``` r
attributes(titanicData)$names # take a look at the different variables we have
```

    ##  [1] "pclass"    "survived"  "name"      "sex"       "age"       "sibsp"     "parch"     "ticket"   
    ##  [9] "fare"      "cabin"     "embarked"  "boat"      "body"      "home.dest"

Here are the variables we have access to. I think we will keep it to
pclass, sex, and age for predictors. I think a couple of these variables
will have some collinearity.

We will also just take a quick look at what the table would look like to
make sure we don’t miss anthing

``` r
knitr::kable(head(titanicData)) # A simple table to see example data
```

| pclass | survived | name                                            | sex    |     age | sibsp | parch | ticket |     fare | cabin   | embarked | boat | body | home.dest                       |
|---:|----:|:-----------------|:---|---:|---:|---:|:---|----:|:---|:----|:--|--:|:-----------|
|      1 |        1 | Allen, Miss. Elisabeth Walton                   | female | 29.0000 |     0 |     0 | 24160  | 211.3375 | B5      | S        | 2    |   NA | St Louis, MO                    |
|      1 |        1 | Allison, Master. Hudson Trevor                  | male   |  0.9167 |     1 |     2 | 113781 | 151.5500 | C22 C26 | S        | 11   |   NA | Montreal, PQ / Chesterville, ON |
|      1 |        0 | Allison, Miss. Helen Loraine                    | female |  2.0000 |     1 |     2 | 113781 | 151.5500 | C22 C26 | S        | NA   |   NA | Montreal, PQ / Chesterville, ON |
|      1 |        0 | Allison, Mr. Hudson Joshua Creighton            | male   | 30.0000 |     1 |     2 | 113781 | 151.5500 | C22 C26 | S        | NA   |  135 | Montreal, PQ / Chesterville, ON |
|      1 |        0 | Allison, Mrs. Hudson J C (Bessie Waldo Daniels) | female | 25.0000 |     1 |     2 | 113781 | 151.5500 | C22 C26 | S        | NA   |   NA | Montreal, PQ / Chesterville, ON |
|      1 |        1 | Anderson, Mr. Harry                             | male   | 48.0000 |     0 |     0 | 19952  |  26.5500 | E12     | S        | 3    |   NA | New York, NY                    |

``` r
glmFit <- glm(survived ~ age*sex*pclass, data = titanicData, family = "binomial")
summary(glmFit)
```

    ## 
    ## Call:
    ## glm(formula = survived ~ age * sex * pclass, family = "binomial", 
    ##     data = titanicData)
    ## 
    ## Deviance Residuals: 
    ##     Min       1Q   Median       3Q      Max  
    ## -3.0381  -0.7029  -0.4614   0.5132   2.4255  
    ## 
    ## Coefficients:
    ##                     Estimate Std. Error z value Pr(>|z|)    
    ## (Intercept)         6.811494   1.617141   4.212 2.53e-05 ***
    ## age                -0.030302   0.041356  -0.733 0.463733    
    ## sexmale            -5.652917   1.771477  -3.191 0.001417 ** 
    ## pclass             -2.153601   0.574775  -3.747 0.000179 ***
    ## age:sexmale         0.003032   0.045641   0.066 0.947042    
    ## age:pclass          0.003824   0.015539   0.246 0.805619    
    ## sexmale:pclass      1.613719   0.647919   2.491 0.012752 *  
    ## age:sexmale:pclass -0.012706   0.018117  -0.701 0.483090    
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## (Dispersion parameter for binomial family taken to be 1)
    ## 
    ##     Null deviance: 1414.62  on 1045  degrees of freedom
    ## Residual deviance:  940.68  on 1038  degrees of freedom
    ##   (264 observations deleted due to missingness)
    ## AIC: 956.68
    ## 
    ## Number of Fisher Scoring iterations: 5

So we can the most significant were the intercept, your class, and your
gender. No surprises there, but there was a noteworth interactino
between sex and class. I would imagine that if you were a man in first
class you probably knew important people.

``` r
predict(glmFit, newdata = data.frame(pclass = c(1,2,3), sex = c('male','female','female'), age = c(25,80,30)),
                type = "response", se.fit = TRUE)
```

    ## $fit
    ##         1         2         3 
    ## 0.4291980 0.6664000 0.4466476 
    ## 
    ## $se.fit
    ##          1          2          3 
    ## 0.05221614 0.15010290 0.04641147 
    ## 
    ## $residual.scale
    ## [1] 1

Surprisingly, we find that 2nd class 80 yr old woman would be predicted
more likely to survive than a 30 yr old woman in 3rd class.

``` r
ggiraphExtra::ggPredict(glmFit)
```

    ## Warning in eval(family$initialize): non-integer #successes in a binomial glm!

    ## Warning in eval(family$initialize): non-integer #successes in a binomial glm!

    ## Warning in eval(family$initialize): non-integer #successes in a binomial glm!

    ## Warning in eval(family$initialize): non-integer #successes in a binomial glm!

    ## Warning in eval(family$initialize): non-integer #successes in a binomial glm!

    ## Warning in eval(family$initialize): non-integer #successes in a binomial glm!

![](C:/Users/dcraig/Documents/Repos/d-ev-craig.github.io/_posts/2022-08-02-Blog-Post-4-Favorite-Model_files/figure-markdown_github/unnamed-chunk-81-1.png)
Observing our graph we can also see the significant increase at the
middle class in the count of female survivors in comparison to male
survivors in 1st or 3rd class.

This may also be due to how many survivors there were of either gender
at each class, but we can delve into that another time.

In summary of why I like logistic regression, and regression in general,
its easier in my experience to tell what matters and when. I’ve spent
more time in other classes looking at the amount of variability
explained by adding and removing matters and it was mainly focused on
regression examples. SO maybe I’m biased, but I think the power of
logistic regression in these yes/no type scenarios to be concretely
useful.

R to make this post:
#rmarkdown::render(“\_Rmd/2022-07-10-Project-2-Blog-Post.Rmd”,output_format
= #md_document(“markdown_github”),output_dir = “\_posts”, output_options
= list(keep_html=FALSE))
