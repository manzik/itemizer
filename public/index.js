// Note: Bad frontend design (no separation of concerns, no frontend validation, etc.).
// But for the sake of simplicity, and considering that this project's focus is 
// backend design, I did not focus on the frontend design and implementation quality.

const {
  colors,
  CssBaseline,
  ThemeProvider,
  Typography,
  Container,
  createTheme,
  Box,
  SvgIcon,
  Link,
  Grid,
  Stack,
  Item,
  Button,
  Card,
  CardContent,
  CardHeader,
  CardActions,
  CardMedia,
  TextField,
  Snackbar,
  Alert,
  Modal,
  Select,
  MenuItem,
} = MaterialUI;

const EditableField = ({
  value,
  onChange,
  label,
  ...props
}) => {
  return <div>
    <Typography color="text.secondary">
      {label}
    </Typography>
    <TextField defaultValue={value} onChange={onChange} {...props}></TextField>
  </div>;
};
const Products = ({
  showError
}) => {
  const [openNewProductModal, setOpenNewProductModal] = React.useState(false);
  const [newProductName, setNewProductName] = React.useState("");
  const [newProductDescription, setNewProductDescription] = React.useState("");
  const [newProductQuantity, setNewProductQuantity] = React.useState("");

  const [products, setProducts] = React.useState([]);
  const loadProducts = () => {
    axios.get("/api/v1/products")
      .then(({ data: res }) => setProducts(res.data))
      .catch(onError);
  };
  React.useEffect(() => {
    loadProducts();
  }, []);

  const onError = (err) => {
    let errors = (err.response.data.errors && err.response.data.errors.join("\n")) || err.toString();
    let message = "Error(s):\n" + errors;
    setProducts([]);
    loadProducts();
    setTimeout(() => showError(message), 100);
  }

  return (
    <div>
      <Stack 
            direction="column"
            justifyContent="flex-start"
            alignItems="center"
            spacing={3}
          >
            <Box
              display="flex"
              justifyContent="center"
              alignItems="center"
              style={{
                marginTop: 20
              }}
            >
              <Button
                variant="outlined"
                onClick={() => setOpenNewProductModal(true)}
              >
                New
              </Button>
            </Box>
            {
              products.sort((productA, productB) => productA.id - productB.id).map(product => (
                <Card key={product.id} style={{ border: "1px rgba(0, 0, 0, 0.23) solid" }}>
                  <CardContent>
                    <Typography sx={{ fontSize: 12 }} color="text.secondary" gutterBottom>
                      Product ID: {product.id}
                    </Typography>
                    <EditableField
                      value={product.name}
                      onChange={(e) => {
                        axios.put(`/api/v1/products/${product.id}`, { name: e.target.value })
                        .then(({ data: res }) => {
                          setProducts(products.map(p => p.id === product.id ? res.data : p));
                        })
                        .catch(onError);
                      }}
                      label="Product Name"
                    />
                    <br/>
                    <EditableField
                      value={product.description}
                      onChange={(e) => {
                        axios.put(`/api/v1/products/${product.id}`, { description: e.target.value })
                        .then(({ data: res }) => {
                          setProducts(products.map(p => p.id === product.id ? res.data : p));
                        })
                        .catch(onError);
                      }}
                      label="Product Description"
                    />
                    <br/>
                    <EditableField
                      value={product.quantity}
                      onChange={(e) => {
                        axios.put(`/api/v1/products/${product.id}`, { quantity: e.target.value })
                        .then(({ data: res }) => {
                          setProducts(products.map(p => p.id === product.id ? res.data : p));
                        })
                        .catch(onError);
                      }}
                      label="Product Quantity"
                      type="number"
                    />
                    <br/>
                    <Button variant="contained" color="error"
                      onClick={() => {
                        axios.delete(`/api/v1/products/${product.id}`)
                        .then(() => {
                          setProducts(products.filter(p => p.id !== product.id));
                        }).catch(onError);
                      }}>
                        Delete
                    </Button>
                  </CardContent>
                </Card>
              ))
            }
      </Stack>
      <Modal
        open={openNewProductModal}
        onClose={() => setOpenNewProductModal(false)}
      >
        <Box sx={{
          position: "absolute",
          top: "50%",
          left: "50%",
          transform: "translate(-50%, -50%)",
          width: 400,
          bgcolor: "background.paper",
          boxShadow: 24,
          p: 4,
        }}>
          <Typography id="modal-modal-title" variant="h6" component="h2">
            Create new product
          </Typography>
          <br/>
          <TextField
            id="outlined-basic"
            label="Product Name"
            variant="outlined"
            value={newProductName}
            onChange={(e) => setNewProductName(e.target.value)}
          />
          <br/>
          <br/>
          <TextField
            id="outlined-basic"
            label="Product Description"
            variant="outlined"
            value={newProductDescription}
            onChange={(e) => setNewProductDescription(e.target.value)}
          />
          <br/>
          <br/>
          <TextField
            id="outlined-basic"
            label="Product Quantity"
            variant="outlined"
            type="number"
            value={newProductQuantity}
            onChange={(e) => setNewProductQuantity(e.target.value)}
          />
          <br/>
          <br/>
          <Button variant="contained" color="primary"
            onClick={() => {
              axios.post("/api/v1/products", {
                name: newProductName,
                description: newProductDescription,
                quantity: newProductQuantity
              })
              .then(({ data: res }) => {
                setProducts([...products, res.data]);
                setOpenNewProductModal(false);
              })
              .catch(onError);
            }
          }>
            Create
          </Button>
        </Box>
      </Modal>
    </div>
  );
}

const ShippingProductCreator = ({
  onError,
  shipment,
  products,
  loadShipmentsAndProducts
}) => {
  const [chosenProduct, setChosenProduct] = React.useState(products && products.length ? products[0].id : null);
  const [chosenQuantity, setChosenQuantity] = React.useState(1);
  return <div>
    <Select
      value={chosenProduct}
      label="Product"
      onChange={(e) => setChosenProduct(e.target.value)}
    >
      {
        products.map(product => (
          <MenuItem key={product.id} value={product.id}>
            {product.name} ({product.quantity} in stock)
          </MenuItem>
        ))
      }
    </Select>
    <TextField
      variant="outlined"
      type="number"
      value={chosenQuantity}
      onChange={(e) => setChosenQuantity(e.target.value)}
    />
    <Button
      variant="outlined"
      onClick={() => {
        axios.post(`/api/v1/shipments/${shipment.id}/shipping_products`, {
          shipment_id: shipment.id,
          product_id: chosenProduct,
          quantity: chosenQuantity
        })
        .then(({ data: res }) => {
          setChosenProduct(1);
          setChosenQuantity(1);
          products.push(res.data);
          loadShipmentsAndProducts();
        })
        .catch(onError);
      }}
    >
      Add Shipping Product
    </Button>
  </div>
};

const Shipments = ({
  showError
}) => {
  const [openNewShipmentModal, setOpenNewShipmentModal] = React.useState(false);
  const [newShipmentTrackingNumber, setNewShipmentTrackingNumber] = React.useState("");
  const [newShipmentRecipientName, setNewShipmentRecipientName] = React.useState("");
  const [newShipmentRecipientEmail, setNewShipmentRecipientEmail] = React.useState("");
  const [newShipmentRecipientAddress, setNewShipmentRecipientAddress] = React.useState("");

  const [shipments, setShipments] = React.useState([]);
  const [products, setProducts] = React.useState([]);
  const loadShipmentsAndProducts = () => {
    axios.get("/api/v1/shipments")
      .then(({ data: res }) => setShipments(res.data))
      .catch(onError);
    axios.get("/api/v1/products")
      .then(({ data: res }) => setProducts(res.data))
      .catch(onError);
  }

  React.useEffect(() => {
    loadShipmentsAndProducts();
  }, []);

  const onError = (err) => {
    let errors = (err.response.data.errors && err.response.data.errors.join("\n")) || err.toString();
    let message = "Error(s):\n" + errors;
    setShipments([]);
    loadShipmentsAndProducts();
    setTimeout(() => showError(message), 100);
  }

  return (
    <div>
      <Stack
        direction="column"
        justifyContent="flex-start"
        alignItems="center"
        spacing={3}
      >
        <Box
          display="flex"
          justifyContent="center"
          alignItems="center"
          style={{
            marginTop: 20
          }}
        >
          <Button
            variant="outlined"
            onClick={() => setOpenNewShipmentModal(true)}
          >
            New
          </Button>
        </Box>
        {
          shipments.sort((shipmentA, shipmentB) => shipmentA.id - shipmentB.id).map(shipment => (
            <Card key={shipment.id} style={{ border: "1px rgba(0, 0, 0, 0.23) solid" }}>
              <CardContent>
                <Typography sx={{ fontSize: 12 }} color="text.secondary" gutterBottom>
                  Shipment ID: {shipment.id}
                </Typography>
                <EditableField
                  value={shipment.tracking_number}
                  onChange={(e) => {
                    axios.put(`/api/v1/shipments/${shipment.id}`, { tracking_number: e.target.value })
                    .then(({ data: res }) => {
                      setShipments(shipments.map(s => s.id === shipment.id ? res.data : s));
                    })
                    .catch(onError);
                  }}
                  label="Tracking Number"
                />
                <br/>
                <EditableField
                  value={shipment.recipient_name}
                  onChange={(e) => {
                    axios.put(`/api/v1/shipments/${shipment.id}`, { recipient_name: e.target.value })
                    .then(({ data: res }) => {
                      setShipments(shipments.map(s => s.id === shipment.id ? res.data : s));
                    })
                    .catch(onError);
                  }}
                  label="Recipient Name"
                />
                <br/>
                <EditableField
                  value={shipment.recipient_email}
                  onChange={(e) => {
                    axios.put(`/api/v1/shipments/${shipment.id}`, { recipient_email: e.target.value })
                    .then(({ data: res }) => {
                      setShipments(shipments.map(s => s.id === shipment.id ? res.data : s));
                    })
                    .catch(onError);
                  }}
                  label="Recipient Email"
                />
                <br/>
                <EditableField
                  value={shipment.recipient_address}
                  onChange={(e) => {
                    axios.put(`/api/v1/shipments/${shipment.id}`, { recipient_address: e.target.value })
                    .then(({ data: res }) => {
                      setShipments(shipments.map(s => s.id === shipment.id ? res.data : s));
                    })
                    .catch(onError);
                  }}
                  label="Recipient Address"
                />
                <br/>
                <Button variant="contained" color="error"
                  onClick={() => {
                    axios.delete(`/api/v1/shipments/${shipment.id}?return_items=true`)
                    .then(() => {
                      loadShipmentsAndProducts();
                    })
                    .catch(onError);
                  }}
                >
                  Delete Shipment and Send Items Back to Inventory
                </Button>
                <br/>
                <Button variant="contained" color="error"
                  onClick={() => {
                    axios.delete(`/api/v1/shipments/${shipment.id}`)
                    .then(() => {
                      loadShipmentsAndProducts();
                    })
                    .catch(onError);
                  }}
                >
                  Delete Shipment and Discrd Items
                </Button>
                <br/>
                <br/>
                <Typography sx={{ fontSize: 12 }} color="text.secondary" gutterBottom>
                  Shipping Products
                </Typography>
                <ShippingProductCreator products={products} shipment={shipment} onError={onError} loadShipmentsAndProducts={loadShipmentsAndProducts} />
                <br/>
                <Stack
                  direction="column"
                  justifyContent="flex-start"
                  alignItems="center"
                  spacing={3}
                >
                  {
                    shipment.shipping_products.sort((shippingProductA, shippingProductB) => shippingProductB.id - shippingProductA.id).map(shippingProduct => (
                      <Card key={shippingProduct.id} style={{ border: "1px rgba(0, 0, 0, 0.23) solid" }}>
                        <CardContent>
                          <Typography sx={{ fontSize: 12 }} color="text.secondary" gutterBottom>
                            Product ID: {shippingProduct.product.id}
                          </Typography>
                          <Typography sx={{ fontSize: "1rem" }} color="text.secondary">
                            Product Name
                          </Typography>
                          <Typography variant="h6" component="h2">
                            {shippingProduct.product.name}
                          </Typography>
                          <EditableField
                            value={shippingProduct.quantity}
                            onChange={(e) => {
                              axios.put(`/api/v1/shipments/${shipment.id}/shipping_products/${shippingProduct.id}`, { quantity: e.target.value })
                              .then(({ data: res }) => {
                                loadShipmentsAndProducts();
                              })
                              .catch(onError);
                            }}
                            label="Quantity"
                            type="number"
                          />
                          <Typography sx={{ fontSize: 12 }} color="text.secondary" gutterBottom>
                            Inventory Stock: {shippingProduct.product.quantity}
                          </Typography>
                          <Button variant="contained" color="error"
                            onClick={() => {
                            axios.delete(`/api/v1/shipments/${shipment.id}/shipping_products/${shippingProduct.id}?return_items=true`)
                            .then(({ data: res }) => {
                              loadShipmentsAndProducts();
                            })
                            .catch(onError);
                          }}>
                            Delete Item and Send Back to Inventory
                          </Button>
                          <br/>
                          <Button variant="contained" color="error"
                            onClick={() => {
                            axios.delete(`/api/v1/shipments/${shipment.id}/shipping_products/${shippingProduct.id}`)
                            .then(({ data: res }) => {
                              loadShipmentsAndProducts();
                            })
                            .catch(onError);
                          }}>
                            Delete and Discard Item
                          </Button>
                        </CardContent>
                      </Card>
                    ))
                  }
                </Stack>
              </CardContent>
            </Card>
          ))
        }
      </Stack>
      <Modal
        open={openNewShipmentModal}
        onClose={() => setOpenNewShipmentModal(false)}
      >
        <Box sx={{
          position: "absolute",
          top: "50%",
          left: "50%",
          transform: "translate(-50%, -50%)",
          width: 400,
          bgcolor: "background.paper",
          boxShadow: 24,
          p: 4,
        }}>
          <Typography id="modal-modal-title" variant="h6" component="h2">
            Create new shipment
          </Typography>
          <br/>
          <TextField
            id="outlined-basic"
            label="Tracking Number"
            variant="outlined"
            value={newShipmentTrackingNumber}
            onChange={(e) => setNewShipmentTrackingNumber(e.target.value)}
          />
          <br/>
          <br/>
          <TextField
            id="outlined-basic"
            label="Recipient Name"
            variant="outlined"
            value={newShipmentRecipientName}
            onChange={(e) => setNewShipmentRecipientName(e.target.value)}
          />
          <br/>
          <br/>
          <TextField
            id="outlined-basic"
            label="Recipient Email"
            variant="outlined"
            value={newShipmentRecipientEmail}
            onChange={(e) => setNewShipmentRecipientEmail(e.target.value)}
          />
          <br/>
          <br/>
          <TextField
            id="outlined-basic"
            label="Recipient Address"
            variant="outlined"
            value={newShipmentRecipientAddress}
            onChange={(e) => setNewShipmentRecipientAddress(e.target.value)}
          />
          <br/>
          <br/>
          <Button variant="contained" color="primary"
            onClick={() => {
              axios.post("/api/v1/shipments", {
                tracking_number: newShipmentTrackingNumber,
                recipient_name: newShipmentRecipientName,
                recipient_email: newShipmentRecipientEmail,
                recipient_address: newShipmentRecipientAddress
              })
              .then(({ data: res }) => {
                setShipments([...shipments, res.data]);
                setOpenNewShipmentModal(false);
              })
              .catch(onError);
            }
          }>
            Create
          </Button>
        </Box>
      </Modal>
    </div>
  );
}

const App = () => {
  const [currentPage, setCurrentPage] = React.useState("home");
  const [openSnackbar, setOpenSnackbar] = React.useState(false);
  const [snackbarMessage, setSnackbarMessage] = React.useState("");
  const showError = message => {
    setSnackbarMessage(message);
    setOpenSnackbar(true);
  };
  const handleSnackbarClose = reason => {
    if(reason !== "clickaway")
      setOpenSnackbar(false);
  };

  const goToHome = () => setCurrentPage("home");

  const Home = (
    <Grid container style={{ height: "100%" }}>
      <Grid item xs={6} alignItems="stretch">
        <Button fullWidth={true} variant="outlined" style={{height: "100%"}}
          onClick={() => setCurrentPage("products")}
        >
          Inventory Products
        </Button>
      </Grid>
      <Grid item xs={6} alignItems="stretch">
        <Button fullWidth={true} variant="outlined" style={{height: "100%"}}
          onClick={() => setCurrentPage("shipments")}
        >
          Shipments
        </Button>
      </Grid>
    </Grid>
  );

  const backButton = (
    <Box
      display="flex"
      justifyContent="center"
      alignItems="center"
      style={{
        marginTop: 20
      }}
    >
      <Button
        variant="outlined"
        onClick={goToHome}
      >
        <SvgIcon>
          <path d="M15.41 16.09l-4.58-4.59 4.58-4.59L14 5.5l-6 6 6 6z" />
        </SvgIcon>
        Back
      </Button>
    </Box>
  );

  const snackBar = <Snackbar
    open={openSnackbar}
    autoHideDuration={6000}
    onClose={handleSnackbarClose}
    style={{ height: "auto", lineHeight: "28px", padding: 24, whiteSpace: "pre-line" }}
  >
    <Alert severity="error" variant="filled" onClose={handleSnackbarClose}>{snackbarMessage}</Alert>
  </Snackbar>;
  
  let currentPageComponent = {
    home: Home,
    products: (
      <div>
        {backButton}
        <Products showError={showError}/>
        {snackBar}
      </div>
    ),
    shipments: (
      <div>
        {backButton}
        <Shipments showError={showError}/>
        {snackBar}
      </div>
    )
  }[currentPage];

  return currentPageComponent;
}

const theme = createTheme({
  palette: {
    primary: {
      main: "#556cd6",
    },
    secondary: {
      main: "#19857b",
    },
    error: {
      main: colors.red.A400,
    },
  },
});

ReactDOM.render(
  <ThemeProvider theme={theme}>
    <CssBaseline />
    <App />
  </ThemeProvider>,
  document.getElementById("root")
);
