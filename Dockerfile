FROM python:3.10

# Install dependencies
RUN apt-get update && apt-get install -y \
    wget \
    gnupg \
    unzip \
    curl \
    ca-certificates

# Add Google Chrome repository (modern method)
RUN mkdir -p /etc/apt/keyrings

RUN curl -fsSL https://dl.google.com/linux/linux_signing_key.pub \
    | gpg --dearmor -o /etc/apt/keyrings/google-chrome.gpg

RUN echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main" \
    > /etc/apt/sources.list.d/google-chrome.list

# Install Chrome
RUN apt-get update && apt-get install -y google-chrome-stable

# Set working directory
WORKDIR /app

# Copy requirements
COPY requirements.txt .

RUN pip install -r requirements.txt

# Copy project files
COPY . .

# Run Streamlit
CMD ["streamlit", "run", "app.py", "--server.port=8501", "--server.address=0.0.0.0"]
