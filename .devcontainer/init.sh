if [ ! -e ./.env ]; then
    echo WARNING. INSECURE DEFAULTS BEING SET FROM A SAMPLE FILE.
    echo SEE .env.sample FOR INSTRUCTIONS.
    cp ./.env.sample ./.env
fi