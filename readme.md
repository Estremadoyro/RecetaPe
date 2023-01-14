## RecetaPe
### Arquitectura
#### VIPER-M
La aplicación principalmente se realizó con VIPER-M dónde M representa una clase Module encargada de referenciar al presenter de la vista y construir la arquitectura para esa pantalla.

#### MVVM
Debido a falta de tiempo por temas de trabajo y personales el componente del Map se realizó con MVVM.

#### Design Pattterns
La app utliza mucho el patron **Factory**, además de en algunos componentes que implementan **Singleton** pero se mantiene a un límite.

#### SOLID
Se aplicaron y siguieron los principios de desarrollo tanto SOLID como CLEAN como fuese posible. Aprovechando el desarrollo POP. 

#### Alto nivel
##### Boot
RecetaPe está creado de una forma medianamente escalable. Tanto la pantalla de Home como Detail son *booteables* esto significa que al cambiar un *enum* posible bootear la app desde diferentes pantallas para incrementar la velocidad de desarrollo. Principalmente en Macs intel based.

##### Modulos
La app es creada de forma modular, dónde existe un módulo principal que administra el delivery de otros módulos on-demand.

#### Librerias
Se utilizó **UIKit** y **RxSwift**. La última para desarrollar de una formar reactiva.

#### Mejoras
Una buena cantidad de features se quisieron agregar pero debido a constraints de trabajo y tiempo no se pudieron realizar.
- Prefetching: Hubiese sido óptimo realizar prefetch a las celdas, así las imagenes cargarían con mayor rapidez.
- UICollecitonCell desacoplamiento: Se utilizó un image service para cargar imágenes paero esto fue dentro de la celda y no por fuera o desacopladamente.

#### Pros
- Se ocupó extensamente **UICollectionViewDiffableDataSource** y **UICollectionViewCompositionalLayout**, dejando de lado UITableViews y Collectionviews con delegates y datasources que generan problemas al acceder a items de su celda. 
- Se realizó caching the imágenes
- Se crearon componentes genéricos. 
- La app puede bootear desde más de una pantalla. 
- Dark mode wuju

###### Me quedé sin más tiempo, gracias por leer.

