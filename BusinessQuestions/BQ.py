import firebase_admin
from firebase_admin import credentials, firestore
from dash import Dash, dcc, html
import dash_leaflet as dl
from geopy.geocoders import Nominatim
import plotly.graph_objs as go



# Inicializa la aplicación de Firebase
cred = credentials.Certificate("BusinessQuestions\isis3510-guarap-firebase-adminsdk-dditz-f230210cac.json")
firebase_admin.initialize_app(cred)

# Accede a la colección 'categories'
categories_ref = firestore.client().collection('categories')

# Diccionarios para almacenar los upvotes y las interacciones por categoría
upvotes_por_categoria = {}
interacciones_por_categoria = {}

# Itera a través de las categorías
for category_doc in categories_ref.stream():
    category_name = category_doc.id

    # Accede a la colección de posts para esta categoría
    posts_ref = category_doc.reference.collection('posts')

    # Inicializa los contadores para esta categoría
    total_upvotes = 0
    total_interacciones = 0

    # Itera a través de los posts de esta categoría y suma los upvotes y las interacciones
    for post_doc in posts_ref.stream():
        post_data = post_doc.to_dict()
        total_upvotes += post_data['upvotes']
        total_interacciones += post_data['upvotes'] + post_data['downvotes']

    # Almacena los totales en los diccionarios correspondientes
    upvotes_por_categoria[category_name] = total_upvotes
    interacciones_por_categoria[category_name] = total_interacciones

# Encuentra las categorías con más upvotes acumulados
max_upvotes = max(upvotes_por_categoria.values())
categorias_mas_votadas = [cat for cat, upvotes in upvotes_por_categoria.items() if upvotes == max_upvotes]

# Encuentra las categorías con la menor cantidad total de interacciones
min_interacciones = min(interacciones_por_categoria.values())
categorias_menos_interacciones = [cat for cat, interacciones in interacciones_por_categoria.items() if interacciones == min_interacciones]

# Find the total number of categorized posts
total_categorized_posts = 0

# Iterate through the categories
for category_doc in categories_ref.stream():
    if category_doc.id != 'Generic':
        posts_ref = category_doc.reference.collection('posts')
        total_categorized_posts += len(list(posts_ref.stream()))

# Find the total number of all posts, including "Generic" category
total_all_posts = 0

for category_doc in categories_ref.stream():
    posts_ref = category_doc.reference.collection('posts')
    total_all_posts += len(list(posts_ref.stream()))

# Calculate the percentage of categorized posts
percentage_categorized = (total_categorized_posts / total_all_posts) * 100

# Print or display the result
print(f"The percentage of uploaded content categorized by users (excluding 'Generic' category) is {percentage_categorized:.2f}%")


# Initialize lists to store data for the new graph
category_names = []
category_percentages = []
category_post_counts = []

# Iterate through the categories to calculate percentages and counts
for category_doc in categories_ref.stream():
    category_name = category_doc.id
    posts_ref = category_doc.reference.collection('posts')
    post_count = len(list(posts_ref.stream()))

    category_names.append(category_name)
    category_post_counts.append(post_count)
    category_percentages.append((post_count / total_all_posts) * 100)

percentage_with_sign = [f"{percentage:.2f}%" for percentage in category_percentages]

def obtener_lat_long(direccion):
    geolocator = Nominatim(user_agent="myGeocoder")
    location = geolocator.geocode(direccion)
    if location:
        return [location.latitude, location.longitude]
    else:
        return None

# Función para obtener las ubicaciones de los posts
def obtener_ubicaciones():
    ubicaciones = {}
    for category_doc in categories_ref.stream():
        posts_ref = category_doc.reference.collection('posts')
        for post_doc in posts_ref.stream():
            post_data = post_doc.to_dict()
            direccion = post_data.get('address')
            if direccion:
                if direccion not in ubicaciones:
                    ubicaciones[direccion] = 1
                else:
                    ubicaciones[direccion] += 1
    return ubicaciones

def obtener_centroide(coordenadas):
    total_latitud = sum([coord[0] for coord in coordenadas])
    total_longitud = sum([coord[1] for coord in coordenadas])
    cantidad = len(coordenadas)
    centro_latitud = total_latitud / cantidad
    centro_longitud = total_longitud / cantidad
    return [centro_latitud, centro_longitud]

# Obtener las ubicaciones y contar el número de posts en cada ubicación
ubicaciones_posts = obtener_ubicaciones()

# Crear puntos en el mapa para cada ubicación con la cantidad de posts como el tamaño del marcador
puntos_mapa = []
coordenadas_posts = []
for direccion, cantidad_posts in ubicaciones_posts.items():
    coordenadas = obtener_lat_long(direccion)
    if coordenadas:
        coordenadas_posts.append(coordenadas)
        puntos_mapa.append(
            dl.Marker(
                position=coordenadas,
                children=dl.Tooltip(f"{direccion}: {cantidad_posts} posts"),
            )
        )

# Calcular el centroide de las coordenadas de los posts
centroide = obtener_centroide(coordenadas_posts)


# Inicializa la aplicación Dash
app = Dash(__name__)

# Lista de colores para las barras (puedes personalizar estos colores)
colores = ['#aa003e', '#ff914c', '#aa003e', '#ff914c', '#aa003e']

# Diseño del dashboard
app.layout = html.Div([
    html.H1("Business Questions", style={'text-align': 'center', 'font-family': 'Arial', 'color': '#aa003e'}),
    html.Div([
        dcc.Graph(
            id='upvotes-bar-chart',
            figure={
                'data': [
                    go.Bar(
                        x=list(upvotes_por_categoria.keys()),
                        y=list(upvotes_por_categoria.values()),
                        name='Upvotes',
                        marker=dict(color=colores)  # Asignar colores de la lista
                    )
                ],
                'layout': go.Layout(
                    title='Upvotes by Category',
                    xaxis={'title': 'Category'},
                    yaxis={'title': 'Upvotes'}
                )
            }
        ),
        html.H2(f"Which category has the most accumulated upvotes? {' and '.join(categorias_mas_votadas)} ({max_upvotes} upvote(s))", style={'text-align': 'center', 'font-family': 'Arial'}),
        dcc.Graph(
            id='interacciones-bar-chart',
            figure={
                'data': [
                    go.Bar(
                        x=list(interacciones_por_categoria.keys()),
                        y=list(interacciones_por_categoria.values()),
                        name='Interactions',
                        marker=dict(color=colores)  # Asignar colores de la lista
                    )
                ],
                'layout': go.Layout(
                    title='Interactions by Category',
                    xaxis={'title': 'Category'},
                    yaxis={'title': 'Interactions'}
                )
            }
        ),
        html.H2(f"Which category has the least total interactions (upvotes/downvotes)? {' and '.join(categorias_menos_interacciones)} ({min_interacciones} interaction(s))", style={'text-align': 'center', 'font-family': 'Arial'}),
        dcc.Graph(
            id='category-bar-chart',
            figure={
                'data': [
                    go.Bar(
                        x=category_names,
                        y=category_percentages,
                        text=percentage_with_sign,  # Display percentages on top of bars
                        textposition='auto',  # Display text automatically
                        name='Percentage',  # Update the name to 'Percentage'
                        marker=dict(color=colores)  # Asignar colores de la lista
                    )
                ],
                'layout': go.Layout(
                    title='Category Statistics',
                    xaxis={'title': 'Category'},
                    yaxis={'title': 'Percentage of Total Posts'},  # Update the y-axis title
                )
            }
        ),
        html.H2(f"What percentage of the uploaded content is categorized by the user so that others can search by category?", style={'text-align': 'center', 'font-family': 'Arial'}),

        html.Div([
        dl.Map(center=centroide, zoom=10, children=[
            dl.TileLayer(),
            *puntos_mapa
        ], style={'width': '100%', 'height': '50vh'}),
    ], style={'margin': '30px auto', 'text-align': 'center'}),
        html.H2(f"From which locations are users posting?", style={'text-align': 'center', 'font-family': 'Arial'}),

    ]),
])

if __name__ == '__main__':
    app.run_server(debug=True)
