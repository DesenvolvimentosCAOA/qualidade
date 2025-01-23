//seleciona o campo VIN após o envio do form
window.onload = function() {
    var vinInput = document.getElementById('formVIN');
    vinInput.focus(); // Foca no campo VIN
    vinInput.select(); // Seleciona o texto do campo VIN
};

//determina o modelo baseado no início do VIN
const vinModelMap = {
        "KMHF341EB": "AZERA",
        "95PJ33ALX": "Tucson GLS/LTD",
        "95PJ3812G": "Tucson GLS/LTD",
        "KMHK281HF": "KONA EV",
        "KMHK281EG": "KONA HEV LTD",
        "KMHC851CG": "IONIQ",
        "95PJV81DB": "IX35 GLS",
        "JF1GT7LL5": "SUBARU XV",
        "JF1GTELL5": "SUBARU XV",
        "JF1SK7LL5": "FORESTER",
        "JF1SKELL5": "FORESTER",
        "JF1VAGL85": "FORESTER",
        "JF1VAFLH3": "SUBARU WRX",
        "JF1BSFLC2": "OUTBACK",
        "KMHSU81ED": "SANTA FÉ",
        "95PZBN7KP": "HR DA10/12",
        "95PGA18FP": "HD80",
        "95PEJL31D": "Tiggo 7 48v",
        "95PEKL31D": "Tiggo 7 48v ADAS",
        "95PEEL61D": "Tiggo 7 ADAS",
        "95PACL51D": "Tiggo 7 TXS",
        "95PAAL51B": "Tiggo 7 T",
        "95PEFL31D": "Tiggo 7 ICE LOW",
        "95PEDL61D": "Tiggo 7 PRO",
        "95PBDK51D": "Tiggo 5x PRO",
        "95PBFK31D": "Tiggo 5x PRO ICE LOW",
        "95PBKK31D": "Tiggo 5x PRO ADAS HIGH",
        "95PBDK31D": "Tiggo 5x PRO ICE HIGH",
        "95PBJK31D": "Tiggo 5x 48v",
        "95PBLK31D": "TIGGO 5x 48v ADAS LOW",
        "95PBAK51B": "Tiggo 5 T",
        "95PBCK51D": "Tiggo 5 TXS",
        "95PFEM61D": "TIGGO 8 FL3",
        "95PDEM61D": "Tiggo 8 ADAS",
        "95PDCM61D": "Tiggo 8 TXS",
        "LVTDB21B2": "Tiggo 8 TXS",
        "LVTDB21B1": "Tiggo 8 TXS",
        "LVVDB21B5": "Tiggo 8 TXS",
        "LVTDB21BX": "Tiggo 8 TXS",
        "LNNBBDAT0": "Tiggo 8 PHEV",
        "LNNBBDAT1": "Tiggo 8 PHEV",
        "LNNBBDAT2": "Tiggo 8 PHEV",
        "LNNBBDAT3": "Tiggo 8 PHEV",
        "LNNBBDAT4": "Tiggo 8 PHEV",
        "LNNBBDAT5": "Tiggo 8 PHEV",
        "LNNBBDAT6": "Tiggo 8 PHEV",
        "LNNBBDAT7": "Tiggo 8 PHEV",
        "LNNBBDAT8": "Tiggo 8 PHEV",
        "LNNBBDAT9": "Tiggo 8 PHEV",
        "LNNBBDATX": "Tiggo 8 PHEV" ,
        "LVVDC21B0": "Arrizo 6",
        "LVVDC21B1": "Arrizo 6",
        "LVVDC21B2": "Arrizo 6",
        "LVVDC21B3": "Arrizo 6",
        "LVVDC21B4": "Arrizo 6",
        "LVVDC21B5": "Arrizo 6",
        "LVVDC21B6": "Arrizo 6",
        "LVVDC21B7": "Arrizo 6",
        "LVVDC21B8": "Arrizo 6",
        "LVVDC21B9": "Arrizo 6",
        "LVVDC21BX": "Arrizo 6"
};

const vinInput = document.getElementById("formVIN");
const modeloInput = document.getElementById("formModelo");
const vinForm = document.getElementById("form_envio");

vinInput.addEventListener("input", function() {
    const vinValue = vinInput.value.trim();

    // Verifica se o comprimento do VIN é exatamente 17 caracteres
    if (vinValue.length === 17) {
        // Verifica se o VIN começa com algum dos VINs mapeados
        const matchedVin = Object.keys(vinModelMap).find(vin => vinValue.startsWith(vin));

        if (matchedVin) {
            modeloInput.value = vinModelMap[matchedVin]; // Atualiza o modelo correspondente
            vinForm.submit(); // Envia o formulário automaticamente
        } else {
            modeloInput.value = ""; // Limpa o campo se não houver correspondência
        }
    } else {
        modeloInput.value = ""; // Limpa o campo modelo se não for exatamente 17
    }
});

//deletar
function deletar(id) {
    if (confirm("Tem certeza que deseja deletar este item?")) {
       window.location.href = "pdi_entrada.cfm?id=" + id;
    }
 }