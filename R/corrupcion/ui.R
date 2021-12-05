navbarPage(title = "Datatón Anticorrupción 2021", 
           header = tagList(
             useShinydashboard()
           ),
        
           id = "intro",
                 
                 tabPanel("Introducción",
                          box(title="", status = "primary",width = 12, solidHeader = F,
                            h1("Datatón Anticorrupción 2021", align = "center"),
                          ),
                          br(""),
                          box(title="", status = "info",width = 12, solidHeader = F,
                          h2("Terdashianos", align = "center"),
                          h3("Este trabajo es desarrollado como una propesta para el Datatón,
                              nos concentramos en analizar las sanciones impuestas a servidores públicos,
                             dividimos el trabajo en tres partes principales: ", align = "center"),
                          ),
                          br(""),
                          box(title="", status = "warning",width = 12, solidHeader = F,
                          h3("-En primer lugar se observan las inhabilitaciones promedio según la causa de sanción"),
                          h3("-Después se analiza la dispersión entre el ingreso declarado y las multas impuestas por puestos ejercidos"),
                          h3("-Por último se desarrolla un modelo de ML para crear clusters en los datos y observar patrones")
                          ),
                          
                          ),
                 tabPanel("Inhabilitaciones",
                          column(4, 
                            fluidRow(
                              pickerInput("picker_dep_i", "Área de la Dependencia", choices = c(unique(inhabilitacion_shiny$dependencia)),
                                          options = list(`actions-box` = FALSE),multiple = FALSE)
                              )
                          ),
                          fluidRow(
                            highchartOutput("bar_inhabi", height = "80vh", width = "80vh"), width=10, 
                          )
                          ),
                 tabPanel("Multas",
                          column(4, 
                                 fluidRow(
                                   pickerInput("picker_dep_m", "Área de la Dependencia", choices = c(unique(multas_shiny$dependencia)),
                                               options = list(`actions-box` = FALSE),multiple = FALSE)
                                 )
                          ),
                          column(4, 
                                 fluidRow(
                                   pickerInput("picker_cau_m", "Causa de la Sanción", choices = c(unique(multas_shiny$causa)),
                                               options = list(`actions-box` = FALSE),multiple = FALSE)
                                 )
                          ),
                          fluidRow(
                            highchartOutput("scatter_multas", height = "80vh", width = "80vh"), width=8, 
                          )
                          ),
                 tabPanel("Clusters Método",
                          HTML('
                           <section class="hero">
  <div class="container-fluid">
    <div class="row">
      <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
        <h1>Modelo de Clusters</h1>
        <h2>Evaluación y Resultados</h2>
        <h3>Como última parte desarrollamos un modelo de K-means que ayuda a determinar clusters en los datos basándose en centroides, Para determinar los clusters se usó la dependencia, el tipo de sanción, la causa de la sanción, género e ingreso</h3>
                           </div>
                             </div>
                             </div>
                             </section>
                           '),
                          fluidRow(
                              column(6,
                              HTML('<p><img src="elbone_score.jpg"/></p>')
                            ),
                            box(title = "Elbone Score", status = "primary", width = 4,  solidHeader = TRUE,
                                p("Para determinar la cantidad óptima de clusters se pueden realizar dos
                                  dos pruebas principales, la primera llamada Elbone Score indica el
                                  óptimo en donde la recta sea curva, para este caso se presenta entre 2 y 5"),
                            )
                          ),
                          fluidRow(
                            column(6,
                                   HTML('<p><img src="silhouette_score.jpg"/></p>')
                                   ),
                            box(title = "Silhouette Score", status = "primary", width = 4,  solidHeader = TRUE,
                                p("una forma más eficazpara determinar la cantidad de clusters es el método
                                  Silhouette Score, en conde el valor más bajo en este score determina el óptimo
                                  de clusters del modelo, para este caso la mejor opción parecen ser 4 Clusters
                                  y es la opción elegida"),
                            )
                          ),
                          fluidRow(
                            column(6,
                                   HTML('<p><img src="clusters.jpg"/></p>')
                            ),
                            box(title = "Clusters con K-means", status = "primary", width = 4,  solidHeader = TRUE,
                                p("Por último se aplica el modelo con 4 centroides que generen el mismo número
                                  de clusters, para simplificar este proceso primero se normalizaron los datos
                                  en un rango cerrrado entre 1 y -1, posteriormente Se descompusieron los datos 
                                  reduciendo su dimensionalidad, esto facilita el cálculo y hace más amena la visualización,
                                  A grandes rasgoz los datos parecen estar ya divididos en dos grupos y a partir de estos
                                  el modelo los fragmenta."),
                            )
                          )
                          
                          
                          ),
                 tabPanel("Clusters Resultado",
                          column(4, 
                                 fluidRow(
                                   pickerInput("picker_clus", "Cluster", choices = c(unique(cluster_fshiny$cluster)),
                                               options = list(`actions-box` = FALSE),multiple = FALSE)
                                 )
                          ),
                          column(4, 
                                 fluidRow(
                                   pickerInput("picker_clus_dep", "Dependencia", choices = c(unique(cluster_fshiny$dependencia)),
                                               selected = "Agricultura", options = list(`actions-box` = TRUE),multiple = TRUE)
                                 )
                          ),
                          fluidRow(
                            highchartOutput("bar_c_val", height = "90vh", width = "90vh"), width=10
                          ),
                          column(4, 
                                 fluidRow(
                                   pickerInput("picker_clus_income", "Cluster", choices = c(unique(c_mean_income$cluster)),
                                               options = list(`actions-box` = FALSE),multiple = FALSE)
                                 )
                          ),
                          column(4, 
                                 fluidRow(
                                     pickerInput("picker_clus_sanc", "Sanción", choices = c(unique(c_mean_income$sancion)),
                                               options = list(`actions-box` = FALSE),multiple = FALSE)
                                 )
                          ),
                          fluidRow(
                            highchartOutput("bar_c_inc", height = "90vh", width = "90vh"), width=10
                          )
                 )
)

